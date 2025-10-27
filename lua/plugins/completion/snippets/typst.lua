return {
    s({
        trig = "fig",
    },
    {
        t({"#Figure(", "\t"}),
        t("box(image(\""), i(1), t("\", width: "), i(2, "50%"),
        t({"),),", "\t"}),
        t("caption: ["), i(3), t({"],", ")"}),
    }),
}
