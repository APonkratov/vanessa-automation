﻿//начало текста модуля

///////////////////////////////////////////////////
//Служебные функции и процедуры
///////////////////////////////////////////////////

&НаКлиенте
// контекст фреймворка Vanessa-Behavior
Перем Ванесса;
 
&НаКлиенте
// Структура, в которой хранится состояние сценария между выполнением шагов. Очищается перед выполнением каждого сценария.
Перем Контекст Экспорт;
 
&НаКлиенте
// Структура, в которой можно хранить служебные данные между запусками сценариев. Существует, пока открыта форма Vanessa-Behavior.
Перем КонтекстСохраняемый Экспорт;

&НаКлиенте
// Функция экспортирует список шагов, которые реализованы в данной внешней обработке.
Функция ПолучитьСписокТестов(КонтекстФреймворкаBDD) Экспорт
	Ванесса = КонтекстФреймворкаBDD;
	
	ВсеТесты = Новый Массив;

	//описание параметров
	//Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,Снипет,ИмяПроцедуры,ПредставлениеТеста,ОписаниеШага,ТипШага,Транзакция,Параметр);

	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ВБазеНетЭлементовСправочникаСУказаннымиВТаблицеНаименованиями(Парам01,ТабПарам)","ВБазеНетЭлементовСправочникаСУказаннымиВТаблицеНаименованиями","Дано в базе нет элементов справочника ""Справочник1"" с указанными в таблице наименованиями","","");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯПодключаюTestClientЛогинПароль(Парам01,Парам02,Парам03)","ЯПодключаюTestClientЛогинПароль","И я подключаю TestClient ""Кладовщик"" логин ""Пользователь1"" пароль ""1""","Позволяет подключить TestClient с нужным логином и паролем в тойже базе, в которой запущен TestManager","Подключение TestClient.Новое подключение к той же базе, где запущен TestManager");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯСоздаюЭлементГдеНаименованиеРавноИмениПользователя(Парам01)","ЯСоздаюЭлементГдеНаименованиеРавноИмениПользователя","И я создаю элемент ""Справочник1"" где Наименование равно имени пользователя","","");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯАктивизируюTestClient(Парам01)","ЯАктивизируюTestClient","И я активизирую TestClient ""Кладовщик""","Позволяет переключить контекст на нужный TestClient","Подключение TestClient.Работа с подключенными TestClient");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ВБазеДанныхЕстьЭлементаСНаименованиемРавным(Парам01,Парам02,Парам03)","ВБазеДанныхЕстьЭлементаСНаименованиемРавным","И в базе данных есть 2 элемента ""Справочник1"" с Наименованием равным ""Пользователь1""","","");
	Ванесса.ДобавитьШагВМассивТестов(ВсеТесты,"ЯЗакрываюTestClient(Парам01)","ЯЗакрываюTestClient","И я закрываю TestClient ""Кладовщик""","Закрывает указанный TestClient Перед этим закрывает все окна в нём.","Подключение TestClient.Работа с подключенными TestClient");

	Возврат ВсеТесты;
КонецФункции
	
&НаСервере
// Служебная функция.
Функция ПолучитьМакетСервер(ИмяМакета)
	ОбъектСервер = РеквизитФормыВЗначение("Объект");
	Возврат ОбъектСервер.ПолучитьМакет(ИмяМакета);
КонецФункции
	
&НаКлиенте
// Служебная функция для подключения библиотеки создания fixtures.
Функция ПолучитьМакетОбработки(ИмяМакета) Экспорт
	Возврат ПолучитьМакетСервер(ИмяМакета);
КонецФункции



///////////////////////////////////////////////////
//Работа со сценариями
///////////////////////////////////////////////////

&НаКлиенте
// Процедура выполняется перед началом каждого сценария
Процедура ПередНачаломСценария() Экспорт
	
КонецПроцедуры

&НаКлиенте
// Процедура выполняется перед окончанием каждого сценария
Процедура ПередОкончаниемСценария() Экспорт
	
КонецПроцедуры


&НаСервере
Функция УдалитьЭлементСправочникаЕслиОнЕсть(ВидСправочника,Наименование)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Справочник1.Ссылка
		|ИЗ
		|	Справочник.Справочник1 КАК Справочник1
		|ГДЕ
		|	Справочник1.Наименование = &Наименование";
		
		
	Запрос.Текст = СтрЗаменить(Запрос.Текст,"Справочник1",ВидСправочника);	
	Запрос.УстановитьПараметр("Наименование", Наименование);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СпрОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		Сообщить("Удаляю элемент справочника <" + ВидСправочника + "> : <" + СпрОбъект.Наименование + ">");
		СпрОбъект.Удалить();
	КонецЦикла;
	
КонецФункции	


///////////////////////////////////////////////////
//Реализация шагов
///////////////////////////////////////////////////

&НаКлиенте
//Дано в базе нет элементов справочника "Справочник1" с указанными в таблице наименованиями
//@ВБазеНетЭлементовСправочникаСУказаннымиВТаблицеНаименованиями(Парам01,ТабПарам)
Процедура ВБазеНетЭлементовСправочникаСУказаннымиВТаблицеНаименованиями(ВидСправочника,ТабПарам) Экспорт
	Для Каждого СтрокаТаблицы Из ТабПарам Цикл
		УдалитьЭлементСправочникаЕслиОнЕсть(ВидСправочника,СтрокаТаблицы.Кол1);
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЭлементПодключенныеTestClient(ПодключенныеTestClient,ИмяTestClient)
	Для Ккк = 0 По ПодключенныеTestClient.Количество()-1 Цикл
		Если ПодключенныеTestClient[Ккк].Имя = ИмяTestClient Тогда
			ПодключенныеTestClient.Удалить(Ккк);
			Прервать;
		КонецЕсли;	 
	КонецЦикла;	
КонецПроцедуры

&НаКлиенте
//И я подключаю TestClient "Кладовщик" логин "Пользователь1" пароль "1"
//@ЯПодключаюTestClientЛогинПароль(Парам01,Парам02,Парам03)
Процедура ЯПодключаюTestClientЛогинПароль(ИмяTestClient,Логин,Пароль) Экспорт
	Если Не КонтекстСохраняемый.Свойство("ПодключенныеTestClient") Тогда
		КонтекстСохраняемый.Вставить("ПодключенныеTestClient",Новый Массив);
	КонецЕсли;	 
	
	ПодключенныеTestClient = КонтекстСохраняемый.ПодключенныеTestClient;
	
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Имя",ИмяTestClient);
	МассивСтрок = Ванесса.ДанныеКлиентовТестирования.НайтиСтроки(ПараметрыОтбора);
	Если МассивСтрок.Количество() = 0 Тогда //значит нет такого профиля в таблице
		ПараметрыОтбора = Новый Структура;
		ПараметрыОтбора.Вставить("Имя","Этот клиент"); //будем копировать эту строку
		
		МассивСтрок = Ванесса.ДанныеКлиентовТестирования.НайтиСтроки(ПараметрыОтбора);
		Если МассивСтрок.Количество() = 0 Тогда
			ВызватьИсключение "Не найдена строка в таблице ДанныеКлиентовТестирования с <Имя=Этот клиент>";
		КонецЕсли;	 
		
		СтрокаЭтотКлиент = МассивСтрок[0];
		
		СтрокаДанныеКлиентовТестирования = Ванесса.ДанныеКлиентовТестирования.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаДанныеКлиентовТестирования,СтрокаЭтотКлиент);
		
		ДопПараметры = "";
		Если ЗначениеЗаполнено(Логин) Тогда
			ДопПараметры = ДопПараметры + "/N""" + Логин + """ ";
		КонецЕсли;	 
		Если ЗначениеЗаполнено(Пароль) Тогда
			ДопПараметры = ДопПараметры + "/P""" + Пароль + """ ";
		КонецЕсли;	 
		
		СтрокаДанныеКлиентовТестирования.Имя                    = ИмяTestClient;
		СтрокаДанныеКлиентовТестирования.ПортЗапускаТестКлиента = Ванесса.ПроверитьПортНаЗанятость(48000);
		СтрокаДанныеКлиентовТестирования.ДопПараметры           = ДопПараметры;
	КонецЕсли;	 
	
	
	Если НЕ Ванесса.ПодключитьПрофильTestClientПоИмени(ИмяTestClient) Тогда
		ВызватьИсключение "Не смог подключить профиль TestClient <" + ИмяTestClient + ">";
	КонецЕсли;	 
	
	ТестовоеПриложение      = КонтекстСохраняемый.ТестовоеПриложение;
	ГлавноеОкноТестируемого = КонтекстСохраняемый.ГлавноеОкноТестируемого;
		
	УдалитьЭлементПодключенныеTestClient(ПодключенныеTestClient,ИмяTestClient);
	
	ПодключенныеTestClient.Добавить(Новый Структура("Имя,ТестовоеПриложение,ГлавноеОкноТестируемого",ИмяTestClient,ТестовоеПриложение,ГлавноеОкноТестируемого));
	КонтекстСохраняемый.Вставить("ТекущийПрофильTestClient",ИмяTestClient);
	
КонецПроцедуры

&НаКлиенте
//И я создаю элемент "Справочник1" где Наименование равно имени пользователя
//@ЯСоздаюЭлементГдеНаименованиеРавноИмениПользователя(Парам01)
Процедура ЯСоздаюЭлементГдеНаименованиеРавноИмениПользователя(ВидСправочника) Экспорт
	Ванесса.Шаг("Когда В панели разделов я выбираю ""Основная""");
	Ванесса.Шаг("И     В панели функций я выбираю """ + ВидСправочника + """");
	Ванесса.Шаг("И     я нажимаю на кнопку ""Создать""");
	Ванесса.Шаг("И     я нажимаю на кнопку ""Ввести в наименование имя пользовтаеля""");
	Ванесса.Шаг("И     я нажимаю на кнопку ""Записать и закрыть""");
КонецПроцедуры

&НаКлиенте
Функция ПолучитьСвойстваПодключенногоTestClient(ИмяTestClient)
	ПодключенныеTestClient = КонтекстСохраняемый.ПодключенныеTestClient;
	Для Каждого Элем Из ПодключенныеTestClient Цикл
		Если Элем.Имя = ИмяTestClient Тогда
			Возврат Элем;
		КонецЕсли;	 
	КонецЦикла;	
	
	Возврат Неопределено;
КонецФункции	

&НаКлиенте
//И я активизирую TestClient "Кладовщик"
//@ЯАктивизируюTestClient(Парам01)
Процедура ЯАктивизируюTestClient(ИмяTestClient) Экспорт
	Сообщить("ЯАктивизируюTestClient <" + ИмяTestClient + ">");
	
	СвойстваTestClient = ПолучитьСвойстваПодключенногоTestClient(ИмяTestClient);
	Если СвойстваTestClient = Неопределено Тогда
		ВызватьИсключение "Не нашел профиля TestClient с именем <" + ИмяTestClient + ">";
	КонецЕсли;	 
	
	КонтекстСохраняемый.Вставить("ТестовоеПриложение",СвойстваTestClient.ТестовоеПриложение);
	КонтекстСохраняемый.Вставить("ГлавноеОкноТестируемого",СвойстваTestClient.ГлавноеОкноТестируемого);
	КонтекстСохраняемый.Вставить("ТекущийПрофильTestClient",ИмяTestClient);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьКоличествоЭлементовСправочикаПоНаименованию(ВидСправочника,Наименование)
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(Справочник1.Ссылка) КАК КоличествоЭлементов
		|ИЗ
		|	Справочник.Справочник1 КАК Справочник1
		|ГДЕ
		|	Справочник1.Наименование = &Наименование";
		
		
	Запрос.Текст = СтрЗаменить(Запрос.Текст,"Справочник1",ВидСправочника);	
	Запрос.УстановитьПараметр("Наименование", Наименование);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Возврат ВыборкаДетальныеЗаписи.КоличествоЭлементов;
	КонецЦикла;
	
	Возврат 0;
КонецФункции	

&НаКлиенте
//И в базе данных есть 2 элемента "Справочник1" с Наименованием равным "Пользователь1"
//@ВБазеДанныхЕстьЭлементаСНаименованиемРавным(Парам01,Парам02,Парам03)
Процедура ВБазеДанныхЕстьЭлементаСНаименованиемРавным(КоличествоЭлементов,ВидСправочника,Наименование) Экспорт
	КоличествоЭлементовСправочика = ПолучитьКоличествоЭлементовСправочикаПоНаименованию(ВидСправочника,Наименование);
	Если КоличествоЭлементовСправочика <> КоличествоЭлементов Тогда
		ВызватьИсключение "Ожидали <" + КоличествоЭлементов + "> элементов справочника <" + ВидСправочника + ">, а нашли <" + КоличествоЭлементовСправочика + "> элементов.";
	КонецЕсли;	 
КонецПроцедуры

&НаКлиенте
//И я закрываю TestClient "Кладовщик"
//@ЯЗакрываюTestClient(Парам01)
Процедура ЯЗакрываюTestClient(ИмяTestClient) Экспорт
	Сообщить("ЯЗакрываюTestClient <" + ИмяTestClient + ">");
	
	СвойстваTestClient = ПолучитьСвойстваПодключенногоTestClient(ИмяTestClient);
	Если СвойстваTestClient = Неопределено Тогда
		ВызватьИсключение "Не нашел профиля TestClient с именем <" + ИмяTestClient + "> чтобы его закрыть.";
	КонецЕсли;	 
	
	ТекущийПрофильTestClient            = Неопределено;
	НадоВернутьТекущийПрофильTestClient = Ложь;
	Если КонтекстСохраняемый.Свойство("ТекущийПрофильTestClient") Тогда
		ТекущийПрофильTestClient = КонтекстСохраняемый.ТекущийПрофильTestClient;
		
		Если (ТекущийПрофильTestClient <> Неопределено) и (ТекущийПрофильTestClient <> ИмяTestClient) Тогда
			СвойстваТекущийПрофильTestClient = ПолучитьСвойстваПодключенногоTestClient(ТекущийПрофильTestClient);
			Если СвойстваТекущийПрофильTestClient = Неопределено Тогда
				ВызватьИсключение "Не нашел профиля TestClient с именем <" + ТекущийПрофильTestClient + "> хотя он должен быть активным в данный момент.";
			КонецЕсли;	 
			
			НадоВернутьТекущийПрофильTestClient = Истина;
		КонецЕсли;	 
	КонецЕсли;	 
	
	
	Если ИмяTestClient <> ТекущийПрофильTestClient Тогда
		//активизируем этот TestClient, чтобы закрыть в нём все окна
		ЯАктивизируюTestClient(ИмяTestClient);
	КонецЕсли;
	
	Ванесса.Шаг("И Я закрыл все окна клиентского приложения");
	Ванесса.Шаг("И Я закрываю сеанс TESTCLIENT");
	
	// снимем отметку о подключении
	ПараметрыОтбора = Новый Структура;
	ПараметрыОтбора.Вставить("Имя",ИмяTestClient);
	МассивСтрок = Ванесса.ДанныеКлиентовТестирования.НайтиСтроки(ПараметрыОтбора);
	Если МассивСтрок.Количество() = 1 Тогда
		СтрокаЭтотКлиент = МассивСтрок[0];
		СтрокаЭтотКлиент.Подключен = Ложь;
	КонецЕсли;
	
	Если НадоВернутьТекущийПрофильTestClient Тогда
		ЯАктивизируюTestClient(ТекущийПрофильTestClient);
	Иначе	
		КонтекстСохраняемый.Вставить("ТекущийПрофильTestClient",Неопределено);
	КонецЕсли;	 
	
	
	УдалитьЭлементПодключенныеTestClient(КонтекстСохраняемый.ПодключенныеTestClient,ИмяTestClient);
	Если КонтекстСохраняемый.ПодключенныеTestClient.Количество() = 0 Тогда
		КонтекстСохраняемый.Вставить("ТекущийПрофильTestClient",Неопределено);
	КонецЕсли;	 
	
КонецПроцедуры

//окончание текста модуля