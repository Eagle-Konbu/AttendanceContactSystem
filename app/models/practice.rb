class Practice < ApplicationRecord
    has_many :contacts, dependent: :delete_all
    scope :can_attend_to, ->(member) do
        if member.is_obog
            where(includes_obog: true)
        else
            all
        end
    end
    scope :order_practice, -> { order(:date).order(:start_time) }
    # Ex:- scope :active, -> {where(:active => true)}

    def display_short_name
        self.name + " (" + self.display_short_date + ")"
    end

    def display_name
        str = self.name + " (" + self.date.strftime("%-m月%-d日") + " " + %w(日 月 火 水 木 金 土)[self.date.wday] + "曜日"
        unless self.place.nil? or self.place == ""
            str += " @" + self.place
        end
        str += "）"

        return str
    end
    def display_short_date
        return self.date.strftime("%-m/%-d") + "(" + %w(日 月 火 水 木 金 土)[self.date.wday] + ")"
    end
    def display_date
        return self.date.strftime("%-m月%-d日") + "(" + %w(日 月 火 水 木 金 土)[self.date.wday] + ")"
    end
    def display_long_date
        return self.date.strftime("%Jy") + "年" + self.display_date
    end
    def display_place
        if self.place == "" or self.place.nil?
            return "@N/A"
        else
            return "@" + self.place
        end
    end

    def notice_time
        base_time = self.start_time.change(year: self.date.year, month: self.date.month, day: self.date.day)
        case self.notice_before
        when "before_15m"
            return base_time - 15.minutes
        when "before_30m"
            return base_time - 30.minutes
        when "before_1h"
            return base_time - 1.hour
        when "before_2h"
            return base_time - 2.hours
        when "before_6h"
            return base_time - 6.hours
        when "before_1d"
            time = base_time - 1.day
            return time.change(hour: 12, min: 0, sec: 0)
        else
            return nil
        end
    end

    def default_name
        case self.kind
        when 'normal'
            return "通練"
        when 'part_time'
            str = "コマ練"
            return str
        when 'run_thru'
            str = "通し"
            num_of_run_thru = Practice.where(kind: 'run_thru').where('date <= ?', Date.today).count
            if num_of_run_thru < 20
                return str + ("①".ord + num_of_run_thru).chr
            else
                return str
            end
        else
            return nil
        end
    end

    def aveilable_for(member)
        if member.leave_on_absence
            return false
        end
        if member.is_obog && !self.includes_obog
            return false
        end
        return true
    end

    def overdue
        practice_date = self.date
        return (Time.now > Time.new(practice_date.year, practice_date.month, practice_date.day, 12, 0, 0) - 1.day)
    end

    def attend_rate(generation = nil)
        if generation.nil?
            return (Contact.where(status: 0, practice_id: self.id).count + Contact.where(status: 2, practice_id: self.id).count + Contact.where(status: 3, practice_id: self.id).count).to_f / Member.valid_members(self).count
        else
            return (Contact.where(status: 0, practice_id: self.id).left_joins(:member).where(members: { generation: generation }).count + Contact.where(status: 2, practice_id: self.id).left_joins(:member).where(members: { generation: generation }).count + Contact.where(status: 3, practice_id: self.id).left_joins(:member).where(members: { generation: generation }).count).to_f / Member.valid_members(self).where(generation: generation ).count
        end
    end

    def detail_line_message
        rate_color = "#e2041b"
        date_color = "#007bbb"

        min_generation = Member.minimum(:generation)
        max_generation = Member.maximum(:generation)

        #0:attend 1:absent 2:late 3:go_early 4:other
        counts = (0..4).map {|i| Contact.where(status: i, practice_id: self.id).count }
        unsubmitted_count = (Member.valid_members(self).count - counts.sum).to_s

        attend_rate_text = (self.attend_rate * 100).round(1).to_s + "%"

        attend_rates = (12..14).map {|i| (self.attend_rate(i) * 100).round(1).to_s + "%" }
        submitted_rate_text = (counts.sum.to_f / Member.valid_members(self).count * 100).round(1).to_s + "%"

        message = [
            {
            type: "flex",
            altText: self.display_name + "の出欠状況",
            contents: {
                "type": "bubble",
                "body": {
                    "type": "box",
                    "layout": "vertical",
                    "contents": [
                    {
                        "type": "text",
                        "text": self.display_short_date,
                        "weight": "bold",
                        "color": date_color,
                        "size": "sm"
                    },
                    {
                        "type": "text",
                        "text": self.name,
                        "weight": "bold",
                        "size": "xxl",
                        "margin": "md"
                    },
                    {
                        "type": "text",
                        "text": self.display_place,
                        "size": "xs",
                        "color": "#aaaaaa",
                        "wrap": true
                    },
                    {
                        "type": "text",
                        "text": Time.now.strftime("%-m月%-d日 %H:%M現在"),
                        "size": "xs",
                        "color": "#aaaaaa",
                        "align": "end"
                    },
                    {
                        "type": "separator",
                        "margin": "xxl"
                    },
                    {
                        "type": "box",
                        "layout": "vertical",
                        "margin": "xxl",
                        "spacing": "sm",
                        "contents": [
                        {
                            "type": "box",
                            "layout": "horizontal",
                            "contents": [
                            {
                                "type": "text",
                                "text": "出席",
                                "size": "sm",
                                "color": "#555555",
                                "flex": 0
                            },
                            {
                                "type": "text",
                                "text": counts[0].to_s + "名",
                                "size": "sm",
                                "color": "#111111",
                                "align": "end"
                            }
                            ]
                        },
                        {
                            "type": "box",
                            "layout": "horizontal",
                            "contents": [
                            {
                                "type": "text",
                                "text": "欠席",
                                "size": "sm",
                                "color": "#555555",
                                "flex": 0
                            },
                            {
                                "type": "text",
                                "text": counts[1].to_s + "名",
                                "size": "sm",
                                "color": "#111111",
                                "align": "end"
                            }
                            ]
                        },
                        {
                            "type": "box",
                            "layout": "horizontal",
                            "contents": [
                            {
                                "type": "text",
                                "text": "遅刻",
                                "size": "sm",
                                "color": "#555555",
                                "flex": 0
                            },
                            {
                                "type": "text",
                                "text": counts[2].to_s + "名",
                                "size": "sm",
                                "color": "#111111",
                                "align": "end"
                            }
                            ]
                        },
                        {
                            "type": "box",
                            "layout": "horizontal",
                            "contents": [
                            {
                                "type": "text",
                                "text": "早退",
                                "size": "sm",
                                "color": "#555555",
                                "flex": 0
                            },
                            {
                                "type": "text",
                                "text": counts[3].to_s + "名",
                                "size": "sm",
                                "color": "#111111",
                                "align": "end"
                            }
                            ]
                        },
                        {
                            "type": "box",
                            "layout": "horizontal",
                            "contents": [
                            {
                                "type": "text",
                                "text": "未提出",
                                "size": "sm",
                                "color": "#555555",
                                "flex": 0
                            },
                            {
                                "type": "text",
                                "text": unsubmitted_count + "名",
                                "size": "sm",
                                "color": "#111111",
                                "align": "end"
                            }
                            ]
                        },
                        {
                            "type": "separator",
                            "margin": "xxl"
                        }
                        ]
                    },
                    {
                        "type": "box",
                        "layout": "vertical",
                        "contents": [
                        {
                            "type": "box",
                            "layout": "horizontal",
                            "contents": [
                            {
                                "type": "text",
                                "text": "出席率",
                                "size": "sm",
                            },
                            {
                                "type": "text",
                                "text": attend_rate_text,
                                "size": "sm",
                                "align": "end"
                            },
                            ]
                        },
                        {
                            "type": "box",
                            "layout": "vertical",
                            "contents": [
                            {
                                "type": "box",
                                "layout": "vertical",
                                "contents": [
                                {
                                    "type": "filler"
                                }
                                ],
                                "height": "6px",
                                "width": attend_rate_text,
                                "backgroundColor": rate_color
                            }
                            ],
                            "height": "6px",
                            "backgroundColor": "#CCCCCC",
                            "margin": "md"
                        },
                        {
                            "type": "box",
                            "layout": "horizontal",
                            "contents": [
                            {
                                "type": "text",
                                "text": "提出率",
                                "size": "sm",
                            },
                            {
                                "type": "text",
                                "text": submitted_rate_text,
                                "size": "sm",
                                "align": "end"
                            },
                            ],
                            "margin": "lg"
                        },
                        {
                            "type": "box",
                            "layout": "vertical",
                            "contents": [
                            {
                                "type": "box",
                                "layout": "vertical",
                                "contents": [
                                {
                                    "type": "filler"
                                }
                                ],
                                "height": "6px",
                                "width": submitted_rate_text,
                                "backgroundColor": rate_color
                            }
                            ],
                            "height": "6px",
                            "backgroundColor": "#CCCCCC",
                            "margin": "md"
                        },
                        {
                            "type": "separator",
                            "margin": "xxl"
                        }
                        ],
                        "margin": "md"
                    },
                    {
                        "type": "box",
                        "layout": "horizontal",
                        "margin": "md",
                        "contents": [
                        {
                            "type": "button",
                            "action": {
                            "type": "uri",
                            "label": "詳細はコチラ",
                            "uri": "https://kmmy-organize-system.herokuapp.com/executive/contacts_list/" + self.id.to_s
                            }
                        }
                        ]
                    }
                    ]
                },
                "styles": {
                    "footer": {
                    "separator": true
                    }
                }
            }
            },
            {
            type: "flex",
            altText: self.display_name + "の出欠状況",
            contents: {
                "type": "carousel",
                "contents": [
                {
                    "type": "bubble",
                    "size": "micro",
                    "header": {
                    "type": "box",
                    "layout": "vertical",
                    "contents": [
                        {
                        "type": "text",
                        "text": "3年の出席率",
                        "color": "#ffffff",
                        "align": "start",
                        "size": "xl",
                        "gravity": "center",
                        "weight": "bold"
                        },
                        {
                        "type": "text",
                        "text": attend_rates[0],
                        "color": "#ffffff",
                        "align": "start",
                        "size": "xs",
                        "gravity": "center",
                        "margin": "lg"
                        },
                        {
                        "type": "box",
                        "layout": "vertical",
                        "contents": [
                            {
                            "type": "box",
                            "layout": "vertical",
                            "contents": [
                                {
                                "type": "filler"
                                }
                            ],
                            "width": attend_rates[0],
                            "backgroundColor": "#0D8186",
                            "height": "6px"
                            }
                        ],
                        "backgroundColor": "#9FD8E36E",
                        "height": "6px",
                        "margin": "sm"
                        }
                    ],
                    "backgroundColor": "#27ACB2",
                    "paddingTop": "19px",
                    "paddingAll": "12px",
                    "paddingBottom": "16px"
                    },
                    "styles": {
                    "footer": {
                        "separator": false
                    }
                    }
                },
                {
                    "type": "bubble",
                    "size": "micro",
                    "header": {
                    "type": "box",
                    "layout": "vertical",
                    "contents": [
                        {
                        "type": "text",
                        "text": "2年の出席率",
                        "color": "#ffffff",
                        "align": "start",
                        "size": "xl",
                        "gravity": "center",
                        "weight": "bold"
                        },
                        {
                        "type": "text",
                        "text": attend_rates[1],
                        "color": "#ffffff",
                        "align": "start",
                        "size": "xs",
                        "gravity": "center",
                        "margin": "lg"
                        },
                        {
                        "type": "box",
                        "layout": "vertical",
                        "contents": [
                            {
                            "type": "box",
                            "layout": "vertical",
                            "contents": [
                                {
                                "type": "filler"
                                }
                            ],
                            "width": attend_rates[1],
                            "backgroundColor": "#DE5658",
                            "height": "6px"
                            }
                        ],
                        "backgroundColor": "#FAD2A76E",
                        "height": "6px",
                        "margin": "sm"
                        }
                    ],
                    "backgroundColor": "#FF6B6E",
                    "paddingTop": "19px",
                    "paddingAll": "12px",
                    "paddingBottom": "16px"
                    },
                    "styles": {
                    "footer": {
                        "separator": false
                    }
                    }
                },
                {
                    "type": "bubble",
                    "size": "micro",
                    "header": {
                    "type": "box",
                    "layout": "vertical",
                    "contents": [
                        {
                        "type": "text",
                        "text": "1年の出席率",
                        "color": "#ffffff",
                        "align": "start",
                        "size": "xl",
                        "gravity": "center",
                        "weight": "bold"
                        },
                        {
                        "type": "text",
                        "text": attend_rates[2],
                        "color": "#ffffff",
                        "align": "start",
                        "size": "xs",
                        "gravity": "center",
                        "margin": "lg"
                        },
                        {
                        "type": "box",
                        "layout": "vertical",
                        "contents": [
                            {
                            "type": "box",
                            "layout": "vertical",
                            "contents": [
                                {
                                "type": "filler"
                                }
                            ],
                            "width": attend_rates[2],
                            "backgroundColor": "#7D51E4",
                            "height": "6px"
                            }
                        ],
                        "backgroundColor": "#9FD8E36E",
                        "height": "6px",
                        "margin": "sm"
                        }
                    ],
                    "backgroundColor": "#A17DF5",
                    "paddingTop": "19px",
                    "paddingAll": "12px",
                    "paddingBottom": "16px"
                    },
                    "styles": {
                    "footer": {
                        "separator": false
                    }
                    }
                }
                ]
            }
            }
        ]

        return message
    end

    def final_reminder_message
        header_color = "#028760"
        time_text = self.start_time.strftime("%H:%M") + "~" + self.end_time.strftime("%H:%M")
        place_text = (self.place.present?) ? self.place : "N/A"
        belongings_text = (self.belonging.present?) ? self.belonging : "特になし"

        message = {
            type: "flex",
            altText: "本日のお知らせ",
            contents: {
                "type": "bubble",
                "size": "giga",
                "header": {
                  "type": "box",
                  "layout": "vertical",
                  "contents": [
                    {
                      "type": "box",
                      "layout": "vertical",
                      "contents": [
                        {
                          "type": "text",
                          "text": "本日のお知らせ",
                          "color": "#ffffff",
                          "size": "xxl",
                          "flex": 4,
                          "weight": "bold"
                        },
                        {
                          "type": "text",
                          "text": self.name,
                          "color": "#ffffff",
                          "size": "xl",
                          "flex": 4,
                          "weight": "bold"
                        }
                      ]
                    }
                  ],
                  "paddingAll": "20px",
                  "backgroundColor": "#0367D3",
                  "spacing": "md",
                  "paddingTop": "22px"
                },
                "body": {
                  "type": "box",
                  "layout": "vertical",
                  "contents": [
                    {
                      "type": "box",
                      "layout": "horizontal",
                      "contents": [
                        {
                          "type": "text",
                          "text": "場所",
                          "size": "md",
                          "gravity": "center"
                        },
                        {
                          "type": "text",
                          "text": place_text,
                          "gravity": "center",
                          "flex": 6,
                          "size": "md",
                          "align": "end"
                        }
                      ],
                      "spacing": "lg",
                      "cornerRadius": "30px",
                      "margin": "xl"
                    },
                    {
                        "type": "box",
                        "layout": "horizontal",
                        "contents": [
                          {
                            "type": "text",
                            "text": "時間",
                            "size": "md",
                            "gravity": "center"
                          },
                          {
                            "type": "text",
                            "text": time_text,
                            "gravity": "center",
                            "size": "md",
                            "align": "end",
                            "flex": 5
                          }
                        ],
                        "spacing": "lg",
                        "cornerRadius": "30px",
                        "margin": "xl"
                    },
                    {
                      "type": "box",
                      "layout": "horizontal",
                      "contents": [
                        {
                          "type": "text",
                          "text": "持ち物",
                          "size": "md",
                          "gravity": "center"
                        },
                        {
                          "type": "text",
                          "text": belongings_text,
                          "gravity": "center",
                          "size": "md",
                          "align": "end",
                          "flex": 5,
                          "wrap": true
                        }
                      ],
                      "spacing": "lg",
                      "cornerRadius": "30px",
                      "margin": "xl"
                    }
                  ]
                },
                "footer": {
                  "type": "box",
                  "layout": "vertical",
                  "contents": [
                    {
                      "type": "button",
                      "action": {
                        "type": "uri",
                        "label": "連絡未提出の方はコチラ",
                        "uri": "https://kmmy-organize-system.herokuapp.com/contacts/add"
                      }
                    }
                  ]
                },
                "styles": {
                  "footer": {
                    "separator": true,
                    "separatorColor": "#333333"
                  }
                }
              }
        }

        return message
    end

    enum notice_before:{
        before_15m: 0,
        before_30m: 1,
        before_1h: 2,
        before_2h: 3,
        before_6h: 4,
        before_1d: 5
    }

    enum kind:{
        normal: 0,
        run_thru: 1,
        part_time: 2,
        other: 3
    }
    validates :kind, presence: true
    validates :name, presence: true
end
