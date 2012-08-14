<!doctype html>
<html>
    <head>
        <link rel="icon" type="image/png" href="/favicon.png">
        <link rel="apple-touch-icon" type="image/png" href="/apple-touch-favicon.png">
        <title>SharIt</title>
    </head>
    <body>
        <h1>SharIt</h1>
        <p>Shares:</p>
        <ul>
            <li>%if show_link_pasteboard%<a href="index.html">%endif%Pasteboard%if show_link_pasteboard%</a>%endif%</li>
            <li>%if show_link_text%<a href="text.html">%endif%Text%if show_link_text%</a>%endif%</li>
            <li>%if show_link_pictures%<a href="pictures.html">%endif%Pictures%if show_link_pictures%</a>%endif%</li>
        </ul>
        %if clipboard_is_shared%
                <h2>Pasteboard</h2>
                <h3>Text:</h3>
                <form action="%redirectPath%" method="post">
                    <textarea cols="40" rows="5" name="clipboard">%clipboard_text%</textarea>
                    <br/>
                    <input type="hidden" name="redirectPath" value="%redirectPath%" />
                    <input type="submit" value="Update" />
                </form>
                %if clipboard_image%
                <h3>Image:</h3>
                %clipboard_image_share%
                %endif%
        %endif%
        
        %if text_is_shared%
            <h2>Text</h2>
            <h3>Text:</h3>
            <form action="%redirectPath%" method="post">
                <textarea cols="40" rows="5" name="text">%text%</textarea>
                <br/>
                <input type="hidden" name="redirectPath" value="%redirectPath%" />
                <input type="submit" value="Update" />
            </form>
        %endif%

        %if pictures_is_shared%
            %redirectPath%
        %endif%
    </body>
</html>