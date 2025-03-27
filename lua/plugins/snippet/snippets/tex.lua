return {
    s({
        trig = "frame",
        name = "Beamer frame",
        dscr = [[ \begin{frame} ... \end{frame}
        ]],
    },
    {
        t({"\\begin{frame}[fragile]", "\t"}),
        t({"\\frametitle{\\currentdeepesttitle}", "\t"}),
        t({"\\setlength{\\parindent}{2em}", "\t"}),
        t({"\\begin{spacing}{1.5}", "\t\t"}), i(1), t({"", "\t"}),
        t({"\\end{spacing}", ""}),
        t({"\\end{frame}", ""}),
    }),
    s({
        trig = "part",
        name = "Beamder part",
        dscr = [[ \part{}
        ]]
    },
    {
        t("\\part{"), i(1), t({"}"})
    }),
    s({
        trig = "sec",
        name = "Beamer section",
        dscr = [[ \section{}
        ]]
    },
    {
        t("\\section{"), i(1), t({"}"})
    }),

    s({
        trig = "sub",
        name = "Beamer subsection",
        dscr = [[\subsection{}
        ]]
    },
    {
        t("\\subsection{"), i(1), t({"}"})
    }),

    s({
        trig = "subsub",
        name = "Beamer subsubsection",
        dscr = [[ \subsubsection{}
        ]]
    },
    {
        t("\\subsubsection{"), i(1), t({"}"})
    }),

    s({
        trig = "ani",
        name = "Animate item lists",
        dscr = [[ 
\\begin{itemize}[<+->]
    \item ...
\\end{itemize}
        ]]
    },
    {
        t({"\\begin{itemize}[<+->]", "\t"}),
        t({"\\item "}), i(1),

        d(2, function(args, parent, old_state)
            if #args[1][1] > 0 then
                return sn(nil, t({"", "\titms"}))
            else
                return sn(nil, t({""}))
            end
        end, {1}),
        i(3),

        t({"", "\\end{itemize}"}),
    }),

    s({
        trig = "item",
        name = "Item lists",
        dscr = [[ 
\\begin{itemize}
    \\item ${0}
\\end{itemize}
        ]]
    },
    {
        t({"\\begin{itemize}", "\t"}),
        t({"\\item "}), i(1),
        -- d(2, function(args, parent, old_state)
        --     if #args[1][1] > 0 then
        --         return sn(nil, t({"", "\titms"}))
        --     else
        --         return sn(nil, t({""}))
        --     end
        -- end, {1}),
        t({"", "\titms"}), i(2),
        t({"", "\\end{itemize}", ""}),
    }),

    s({
        trig = "itm",
        name = "Single item in itemize list",
    },
    {
        t("\\item "), i(1),
    }),

    s({
        trig = "itms",
        name = "Infinite item in itemize list",
    },
    {
        t("\\item "), i(1),
        t({"", "itms"})
    }),
    s({
        trig = "fig",
        name = "Beamer Figure",
        dscr = [[
\begin{figure}[htb]
    \centering
    \includegraphics[width=0.6\linewidth]{./images/}
    \caption{}
    \label{Fig:}
\end{figure}
        ]]
    },
    {
        t({"\\begin{figure}[htb]", "\t"}),
        t({"\\centering", "\t"}),
        t({"\\includegraphics[scale=1]{./images/"}), i(1), t({"}", "\t"}),
        t("\\caption{"), i(2), t({"}", "\t"}),
        t("\\label{Fig:"),
        f(function(args, snip)
            return args[1][1]:gsub("%.%a+$", "")
        end, {1}),
        t({"}", ""}), t("\\end{figure}"),
    }),

    s({
        trig = "subfig",
        name = "Minipage Subfigure",
        dscr = [[
    \begin{figure}[!h]
        \centering
        \subfigure[子图1]{
            \begin{minipage}[b]{0.45\textwidth}
                \includegraphics[width=1\linewidth]{pic/logo-buaa.eps}\vspace{85pt}
            \end{minipage}
            \label{}
        }
        \subfigure[子图2]{
            \begin{minipage}[b]{0.45\textwidth}
                \includegraphics[width=1\linewidth]{pic/buaa-mark.jpg}
            \end{minipage}
            \label{}
        }
        \caption{测试图片}
    \end{figure}
        ]]
    },
    {
        t({"\\begin{figure}[!h]", "\t"}),
        t({"\\centering", "\t"}),
        t({"\\subfigure["}), i(1, "子图1"), t({"]{", "\t\t"}),
        t({"\\begin{minipage}[b]{0.45\\textwidth}", "\t\t\t"}),
        t({"\\centering", "\t\t\t"}),
        t({"\\includegraphics[scale=1]{./images/"}), i(2),
        t({"}\\vspace{0pt}", "\t\t"}),
        t({"\\end{minipage}", "\t\t"}),
        t({"\\label{fig:"}), f(function(args, snip)
            return args[1][1]:gsub("%.%a+$", "")
        end, {2}),
        t({"}", "\t}"}), t({"", "\t"}),
        t({"\\subfigure["}), i(3, "子图2"), t({"]{", "\t\t"}),
        t({"\\begin{minipage}[b]{0.45\\textwidth}", "\t\t\t"}),
        t({"\\centering", "\t\t\t"}),
        t({"\\includegraphics[scale=1]{./images/"}), i(4),
        t({"}\\vspace{0pt}", "\t\t"}),
        t({"\\end{minipage}", "\t\t"}),
        t({"\\label{fig:"}), f(function(args, snip)
            return args[1][1]:gsub("%.%a+$", "")
        end, {4}),
        t({"}", "\t}"}), t({"", "\t"}),
        t({"\\caption{"}), i(5, "图片标题"), t({"}", "\t"}),
        t({"\\label{fig:"}), i(6), t({"}", ""}),
        t({"\\end{figure}", ""}),
    }),

    s({
        trig = "table",
        name = "Beamer table",
        dscr = [[ 
\begin{scriptsize}
\begin{table}[htpb]
    \centering
    \caption{$0}
    \label{tab:$1}
    \begin{tabular}{m{4cm}<{\centering}m{4cm}<{\centering}}
        \specialrule{0.08em}{4pt}{4pt}
        \specialrule{0.06em}{3pt}{4pt}
        \specialrule{0.00em}{1pt}{1pt}
        \specialrule{0.08em}{2pt}{3pt}
    \end{tabular}
\end{table}
\end{scriptsize}
        ]]
    },
    {
        t({"\\begin{scriptsize} \\begin{table}[htpb]", "\t"}),
        t({"\\centering", "\t"}),
        t({"\\caption{"}), i(1), t({"}", "\t"}),
        t({"\\label{Tab:"}), i(2), t({"}", "\t"}),
        t({"\\begin{tabular}{m{4cm}<{\\centering}m{4cm}<{\\centering}}", "\t\t"}),
        t({"\\specialrule{0.08em}{4pt}{4pt}", "\t\t"}),
        t({"\\specialrule{0.06em}{3pt}{4pt}", "\t\t"}),
        t({"\\specialrule{0.00em}{1pt}{1pt}", "\t\t"}),
        t({"\\specialrule{0.08em}{2pt}{3pt}", "\t"}),
        t({"\\end{tabular}", ""}),
        t({"\\end{table} \\end{scriptsize}", ""})
    }),

    s({
        trig = "lst",
        name = "lstlisting",
        dscr = [[ 
\begin{lstlisting}[style=style]

\end{lstlisting}
        ]]
    },
    {
        isn(nil, t({"", ""}), ""),
        t({"\\begin{lstlisting}[style=style]"}),
        isn(nil, t({"", ""}), ""),
        i(1),
        isn(nil, t({"", ""}), ""),
        t({"\\end{lstlisting}"}),
    }),

    s({
        trig = "rust",
        name = "rust lstlisting",
        dscr = [[ ]]
    },
    {
        isn(nil, t({"", ""}), ""),
        t({"\\begin{scriptsize}","\\begin{spacing}{0.5}", "\\begin{minted}{rust}"}),
        isn(nil, t({"", ""}), ""),
        i(1),
        isn(nil, t({"", ""}), ""),
        t({"\\end{minted}", "\\end{spacing}", "\\end{scriptsize}"}),
    }),

    s({
        trig = "lst2",
        name = "Two columns of lstlisting",
        dscr = [[ 
\begin{columns}[t]
    \column{0.5\textwidth}
    \begin{lstlisting}[style=style]

    \end{lstlisting}
    \column{0.5\textwidth}
    \begin{lstlisting}[style=style]
    \end{lstlisting}
\end{columns}
        ]]
    },
    {
            t({"\\begin{columns}[t]", "\t"}),
            t({"\\column{0.5\\textwidth}"}),
            isn(nil, t({"", ""}), ""),
            t({"\\begin{lstlisting}[style=style]"}),
            isn(nil, t({"", ""}), ""),
            i(1),
            isn(nil, t({"", ""}), ""),
            t({"\\end{lstlisting}"}),
            t({"", "\t"}),
            t({"\\column{0.5\\textwidth}"}),
            isn(nil, t({"", ""}), ""),
            t({"\\begin{lstlisting}[style=style]"}),
            isn(nil, t({"", ""}), ""),
            i(2),
            isn(nil, t({"", ""}), ""),
            t({"\\end{lstlisting}"}),
            t({"", ""}),
            t({"\\end{columns}", ""})
    }),

    s({
        trig = "lsi",
        name = "lstinline",
        dscr = [[ \mintinline{c}{...} ]]
    },
    {
        t("\\mintinline{bash}|"),
         f(function(args, snip)
            local res = ""
            for _, ele in ipairs(snip.env.LS_SELECT_RAW) do
                res = res .. ele
            end
            return res
        end, {}),
        i(1),
        t("|")
    }),

    s({
        trig = "bf",
        name = "textbf",
        dscr = [[ \textbf{}
        ]]
    },
    {
        t("\\textbf{"),
        f(function(args, snip)
            local res = ""
            for _, ele in ipairs(snip.env.LS_SELECT_RAW) do
                res = res .. ele
            end
            return res
        end, {}),
        i(1), t({"}"})
    }),
    s({
        trig = "it",
        name = "textit",
        dscr = [[ \textit{}
        ]]
    },
    {
        t("\\textit{"),
        f(function(args, snip)
            local res = ""
            for _, ele in ipairs(snip.env.LS_SELECT_RAW) do
                res = res .. ele
            end
            return res
        end, {}),
        i(1), t({"}"})
    }),

    s({
        trig = "foot",
        name = "Beamer footnote",
        dscr = [[    \footnote[frame]{footnote content...}
        ]]
    },
    {
        t("\\footnote[frame]{\\tiny "), i(1), t({"}"})
    }),

    s({
        trig = "under",
        name = "underline",
        dscr = [[ \underline{}
        ]]
    },
    {
        t("\\underline{"), i(1), t({"}"})
    }),

    s({
        trig = "para",
        name = "paragraph",
        dscr = [[ \paragraph{}
        ]]
    },
    {
        t("\\paragraph{"), i(1), t({"}", ""})
    }),


    s("code", fmt([==[
    \begin{scriptsize} \begin{spacing}{0.4} \ \\
    \begin{minted}[breaklines=true]{rust}<><>
    \end{minted}
    \ \\ \end{spacing} \end{scriptsize}
    ]==], {
        -- i(1, "rust"),
        isn(nil, t({"", ""}), ""),
        i(1),
    }, {
        delimiters = "<>"
    })),


    s("inline", fmt([==[
        \mintinline{<>}{<>}
    ]==], {
        i(1, "rust"),
        f(function(args, snip)
            local res = ""
            for _, ele in ipairs(snip.env.LS_SELECT_RAW) do
                res = res .. ele
            end
            return res
        end, {}),
    }, {
        delimiters = "<>"
    })),

    s("BLUE", fmt([==[
        \textbf{\color{blue}<>}
    ]==], {
        i(1, "")
    }, {
        delimiters = "<>"
    })),
}
