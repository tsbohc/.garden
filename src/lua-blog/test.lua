local tags = require "tags"
local html,   head,   script,   body,   h1,   p,   td,   tr,   th,   img,   br = tags(
     "html", "head", "script", "body", "h1", "p", "td", "tr", "th", "img", "br")

-- local table = tags(function(rows)
--     local table = table
--     for _, row in ipairs(rows) do
--         for _, col in ipairs(row) do
--             tr(td(col))
--         end
--         table(tr)
--     end
--     return table
-- end)
--
-- print(table{
--     { "A", 1, 1 },
--     { "B", 2, 2 },
--     { "C", 3, 3 }
-- })

print(
   html { lang = "en" } (
      head (
         script { src = "main.js" }
      ),
      body (
         h1 { class = 'title "is" bigger than you think', "selected" } "Hello",
         h1 "Another Headline",
         p (
            "<Beautiful> & <Strange>",
            br,
            { Car = "Was Stolen" },
            "Weather"
         ),
         p "A Dog",
         img { src = "logo.png" },
         table(
            tr (
               th { class = "selected" } "'Headline'",
               th "Headline 2",
               th "Headline 3"
            )
         )
      )
   )
)
