## TRIM

Добавлял уже после того как был написан основной функционал, поэтому для тестирования просто добавил кнопку trim на экран шаринга.
Из библиотек нашел только старую 3-х летнюю https://github.com/titansgroup/k4l-video-trimmer (есть вьюшка для обрезки и пример активити, которая 
ее использует). Попробовал ее. Запускается - слайдерами можно выбрать новую продолжительность, после сохранения и попытки воспроизвести выдает ошибку
в тосте. Если не выдать права, то падает, поэтому вручную в настройках приложения выдал права на хранилище.

В целом стоит для обрезки видео выбрать что-то свежее и рабочее. И повозиться со своим UI. Возможно даже использовать AndroidView для более красивого
встраивания в UI приложения. 

Получается эта часть функционала не работает.

## Краткое описание

Возможность снять видео и расшарить его с телеграммом или любым другим приложением (google photos, instagram и т.д.) как поток видео

## Зависимости

**path_provider** - для работы с путями, getApplicationDocumentsDirectory возвращает путь к папке с приложением и суффиксом app_flutter, что
не очень удобно, если нам нужно расшарить потом данные, которые там сохраняются. Так как при конфигурации файл провайдера мы можем указать
директорию с кешем или files или что-то внешнее (или их подпапки). Поэтому в качестве быстрого решения в методе _getVideosDirectoryPath
я замещаю - docsDirPath.replaceAll("app_flutter", "files"). Думаю по хорошему  самим получать путь нужный без такого хака.

**camera** - работа с камерой.

**sqflite** - база данных

**thumbnails** - генерация картинок первьюшек, код библиотеки показался странным, но работает


## Подробности реализации

На экране съемки видео внизу экрана левая иконка позволяет переключаться между камерами устройства (Если камер больше одной).
При инициализации первой камеры мы сохраняем ее тип (front/back/external) и при запросе на переключение просто ищем первую камеру из списка с другим
типом. Поэтому если будет у устройства все три типа камер, переключаться можно будет только между двумя. Сделанно так для простоты примера.

После съемки в той же директории где и видео создается превью (тоже имя файла, только расширение PNG, а не MP4)

В базе данных сохраняем оба пути, время начала съемки и длину, которую посчитали во время съемки (время окончания минус время начала). Эту длину
в живом приложение лучше брать из метаинформации видео файла.

При клике по карточке с видео открыается экран с возможостью расшарить видео. Видео отдается как поток и на выбор пользователя любое из приложений,
которое к этому готово. Реализованно в **MainActivity** через метод *samples.flutter.io/share_file*

Работа с базой через класс **Repository**. Небольшой хак - инициализация запрашивается в начале метода *getVideos()*, сходу более простое решение не 
нашел. В данном случае это работает, но по хорошему надо по другому. Для простоты примера - singleton.

При реализации экранов попробовал вынести логику работы в так называемые блоки (BLOC). Сами экраны запришивают данные у блоков и ждут.

На экране съемки видео используется отдельный виджет для отрисовки нижних двух кнопок (переключение на другую камеру и съемка). Этому контролу для
свой работы нужен тот же BLOC что и корневому экрану, поэтому я использовал подсмотренный подход и **MakeVideoBlocProvider**. Пока не разобрался 
есть ли хороший аналог даггера в дарте и какие подходы для шаринга компонентов.

Что-то не понятное для меня было при рендеринге **VideoRow**. Иконка превью несмотря на маргины и пэдинги была прибита к топу катрочки, поэтому
я по быстрому не разбираясь нахимичил там с *EdgeInsets.fromLTRB(0, 40, 0, 0)*. Здесь тоже надо разобраться нормально.

В информации о камере есть угол поворота - его тоже никак не учитываю сейча и пока работал в эмуляторе изображение у меня было повернуто на 90 градусов.
В живом приложение нужно будет учитывать.




Возможно что-то забыл упомянуть, пишу уже после реализации.



Протестировал самые простый кейсы (отказ в выдачи пермишенов на съемку например), но серьезно не тестировал и запускал только на своем втором пикселе
так что тут можно было еще поработать



