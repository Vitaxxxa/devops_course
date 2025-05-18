-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Хост: db
-- Время создания: Май 18 2025 г., 15:43
-- Версия сервера: 8.1.0
-- Версия PHP: 8.2.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `SchoolDB`
--

-- --------------------------------------------------------

--
-- Структура таблицы `Children`
--

CREATE TABLE `Children` (
  `child_id` int NOT NULL,
  `first_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `birth_date` date NOT NULL,
  `year_of_entry` int NOT NULL,
  `age` int NOT NULL,
  `institution_id` int DEFAULT NULL,
  `class_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `Children`
--

INSERT INTO `Children` (`child_id`, `first_name`, `last_name`, `birth_date`, `year_of_entry`, `age`, `institution_id`, `class_id`) VALUES
(1, 'Ivan', 'Petrenko', '2012-04-21', 2019, 12, 1, 1),
(2, 'Maria', 'Koval', '2018-09-14', 2023, 6, 2, 2),
(3, 'Oleh', 'Shevchuk', '2011-02-05', 2018, 13, 3, 3);

-- --------------------------------------------------------

--
-- Структура таблицы `Classes`
--

CREATE TABLE `Classes` (
  `class_id` int NOT NULL,
  `class_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `institution_id` int DEFAULT NULL,
  `direction` enum('Mathematics','Biology and Chemistry','Language Studies') COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `Classes`
--

INSERT INTO `Classes` (`class_id`, `class_name`, `institution_id`, `direction`) VALUES
(1, '5-A', 1, 'Mathematics'),
(2, 'Group \"Bee\"', 2, 'Language Studies'),
(3, '8-B', 3, 'Biology and Chemistry');

-- --------------------------------------------------------

--
-- Структура таблицы `Institutions`
--

CREATE TABLE `Institutions` (
  `institution_id` int NOT NULL,
  `institution_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `institution_type` enum('School','Kindergarten') COLLATE utf8mb4_unicode_ci NOT NULL,
  `address` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `Institutions`
--

INSERT INTO `Institutions` (`institution_id`, `institution_name`, `institution_type`, `address`) VALUES
(1, 'Kyiv Gymnasium No. 1', 'School', 'Kyiv, Khreshchatyk 1'),
(2, 'Dnipro Kindergarten \"Sonechko\"', 'Kindergarten', 'Dnipro, Shevchenka 5'),
(3, 'Lviv School No. 23', 'School', 'Lviv, Franka 10');

-- --------------------------------------------------------

--
-- Структура таблицы `Parents`
--

CREATE TABLE `Parents` (
  `parent_id` int NOT NULL,
  `first_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_name` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `child_id` int DEFAULT NULL,
  `tuition_fee` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `Parents`
--

INSERT INTO `Parents` (`parent_id`, `first_name`, `last_name`, `child_id`, `tuition_fee`) VALUES
(1, 'Olena', 'Petrenko', 1, 1500.00),
(2, 'Taras', 'Koval', 2, 1200.00),
(3, 'Iryna', 'Shevchuk', 3, 1600.00);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `Children`
--
ALTER TABLE `Children`
  ADD PRIMARY KEY (`child_id`),
  ADD KEY `institution_id` (`institution_id`),
  ADD KEY `class_id` (`class_id`);

--
-- Индексы таблицы `Classes`
--
ALTER TABLE `Classes`
  ADD PRIMARY KEY (`class_id`),
  ADD KEY `institution_id` (`institution_id`);

--
-- Индексы таблицы `Institutions`
--
ALTER TABLE `Institutions`
  ADD PRIMARY KEY (`institution_id`);

--
-- Индексы таблицы `Parents`
--
ALTER TABLE `Parents`
  ADD PRIMARY KEY (`parent_id`),
  ADD KEY `child_id` (`child_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `Children`
--
ALTER TABLE `Children`
  MODIFY `child_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `Classes`
--
ALTER TABLE `Classes`
  MODIFY `class_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `Institutions`
--
ALTER TABLE `Institutions`
  MODIFY `institution_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `Parents`
--
ALTER TABLE `Parents`
  MODIFY `parent_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `Children`
--
ALTER TABLE `Children`
  ADD CONSTRAINT `Children_ibfk_1` FOREIGN KEY (`institution_id`) REFERENCES `Institutions` (`institution_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `Children_ibfk_2` FOREIGN KEY (`class_id`) REFERENCES `Classes` (`class_id`) ON DELETE SET NULL;

--
-- Ограничения внешнего ключа таблицы `Classes`
--
ALTER TABLE `Classes`
  ADD CONSTRAINT `Classes_ibfk_1` FOREIGN KEY (`institution_id`) REFERENCES `Institutions` (`institution_id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `Parents`
--
ALTER TABLE `Parents`
  ADD CONSTRAINT `Parents_ibfk_1` FOREIGN KEY (`child_id`) REFERENCES `Children` (`child_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
