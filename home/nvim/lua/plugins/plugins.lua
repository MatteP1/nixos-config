-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  {
    "whonore/Coqtail",
  },

  {
    "joom/latex-unicoder.vim",
    init = function()
      vim.g.unicode_map = {
        ["\\fun"] = "λ",
        ["\\mult"] = "⋅",
        ["\\ent"] = "⊢",
        ["\\valid"] = "✓",
        ["\\diamond"] = "◇",
        ["\\box"] = "□",
        ["\\bbox"] = "■",
        ["\\later"] = "▷",
        ["\\pred"] = "φ",
        ["\\and"] = "∧",
        ["\\or"] = "∨",
        ["\\comp"] = "∘",
        ["\\ccomp"] = "◎",
        ["\\all"] = "∀",
        ["\\ex"] = "∃",
        ["\\to"] = "→",
        ["\\sep"] = "∗",
        ["\\lc"] = "⌜",
        ["\\rc"] = "⌝",
        ["\\Lc"] = "⎡",
        ["\\Rc"] = "⎤",
        ["\\lam"] = "λ",
        ["\\empty"] = "∅",
        ["\\Lam"] = "Λ",
        ["\\Sig"] = "Σ",
        ["\\-"] = "∖",
        ["\\aa"] = "●",
        ["\\af"] = "◯",
        ["\\auth"] = "●",
        ["\\frag"] = "◯",
        ["\\iff"] = "↔",
        ["\\gname"] = "γ",
        ["\\incl"] = "≼",
        ["\\latert"] = "▶",
        ["\\update"] = "⇝",
        ['\\"o'] = "ö",
        ["_a"] = "ₐ",
        ["_e"] = "ₑ",
        ["_h"] = "ₕ",
        ["_i"] = "ᵢ",
        ["_k"] = "ₖ",
        ["_l"] = "ₗ",
        ["_m"] = "ₘ",
        ["_n"] = "ₙ",
        ["_o"] = "ₒ",
        ["_p"] = "ₚ",
        ["_r"] = "ᵣ",
        ["_s"] = "ₛ",
        ["_t"] = "ₜ",
        ["_u"] = "ᵤ",
        ["_v"] = "ᵥ",
        ["_x"] = "ₓ",
      }
    end,
  },
}
