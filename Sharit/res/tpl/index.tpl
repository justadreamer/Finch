<!doctype html>
<html>
    <head>
        <link rel="icon" type="image/png" href="/favicon.png" />
        <link rel="apple-touch-icon" type="image/png" href="/apple-touch-favicon.png" />
        <title>SharIt</title>
        <link rel="stylesheet" type="text/css" href="/default.css" />
    </head>
    <body>
        <h1>SharIt</h1>
        <p>Shares:</p>
        <ul>
            <li>%if show_link_pasteboard%<a href="index.html">%endif%Pasteboard%if show_link_pasteboard%</a>%endif%</li>
            <li>%if show_link_text%<a href="text.html">%endif%Text%if show_link_text%</a>%endif%</li>
            <li>%if show_link_pictures%<a href="pictures.html">%endif%Pictures%if show_link_pictures%</a>%endif%</li>
        </ul>
        %if ClipboardShare%
            %if is_shared%
                <h2>Pasteboard</h2>
                <h3>Text:</h3>
                <form action="%redirectPath%" method="post">
                    <textarea cols="40" rows="5" name="%clipboard_field_name%">%clipboard_text%</textarea>
                    <br/>
                    <input type="hidden" name="redirectPath" value="%redirectPath%" />
                    <input name="submit_update" type="submit" value="Update" />
                    <input name="submit_open" type="submit" value="Open Link" />
                </form>
                %if clipboard_image%
                <h3>Image:</h3>
                %clipboard_image_share%
                %endif%
            %else%
                Clipboard sharing is disabled
            %endif%
        %endif%
        
        %if TextShare%
            %if is_shared%
                <h2>Text</h2>
                <h3>Text:</h3>
                <form action="%redirectPath%" method="post">
                    <textarea cols="40" rows="5" name="text">%text%</textarea>
                    <br/>
                    <input type="hidden" name="redirectPath" value="%redirectPath%" />
                    <input type="submit" value="Update" />
                </form>
            %else%
                Text sharing is disabled
            %endif%
        %endif%
        
        %if PicturesShare%
            %if is_shared%
                %pictures_html_block%
            %else%
                Pictures sharing is disabled
            %endif%
            %if is_warning_shown%
            <em style="color:red;">
                Please enable Location Services in the device settings in order to display pictures.
            </em>
            %endif%
        %endif%
    </body>
</html>