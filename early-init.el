;; -*- lexical-binding: t; -*-

;; Faster startup
(setq gc-cons-threshold (* 50 1000 1000))
(setq package-enable-at-startup nil)

;; No GUI cruft (still applies to terminal frames for menu-bar)
(menu-bar-mode -1)
(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)
