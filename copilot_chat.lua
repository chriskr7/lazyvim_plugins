return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    opts = {
      prompts = {
        Review = "Review the following code and provide concise suggestions.",
        Refactor = "Refactor the code to improve clarity and readability.",
      },
    },
    event = "VeryLazy",
    build = function()
      vim.notify("Please update the remote plugins by running ':UpdateRemotePlugins', then restart Neovim.")
    end,
    keys = {
      { "<leader>ccc", ":CopilotChat ", desc = "CopilotChat - Prompt" },
      { "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
      { "<leader>cct", "<cmd>CopilotChatTests<cr>", desc = "CopilotChat - Generate tests" },
      { "<leader>ccr", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
      { "<leader>ccR", "<cmd>CopilotChatRefactor<cr>", desc = "CopilotChat - Refactor code" },
    },
  },
}
