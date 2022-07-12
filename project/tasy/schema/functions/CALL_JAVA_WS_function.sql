-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION call_java_ws ( endpoint text, params params_java_ws_pck.param_tab, ds_key text default '', ds_value text default '') RETURNS varchar AS $body$
DECLARE

    request utl_http.req;
    response utl_http.resp;
    address varchar(255) := obter_valor_param_usuario(0,227,0,wheb_usuario_pck.get_nm_usuario,wheb_usuario_pck.get_cd_estabelecimento);
    url varchar(255) := address || '/javaproc/rest' || endpoint;
    buffer varchar(4000);
    content varchar(4000);
    content_length bigint;
    return_value varchar(4000) := null;
BEGIN
    RAISE NOTICE 'Stating call_java_ws...';
    
	IF (address IS NOT NULL AND address::text <> '') THEN
	    RAISE NOTICE 'Endpoint: %', url;

	    -- Prepare the params in a json format
	    content := '{';
	    FOR i IN 1..params.count LOOP
	        BEGIN
	            content := content || '"' || params[i].ds_key || '":"' || params[i].ds_value || '"';
	            IF (params.count <> i) THEN
	                content := content || ',';
	            END IF;
	        END;
	    END LOOP;
	    content := content || '}';
	    content := REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(content, chr(8), '\b'), chr(9), '\t'), chr(10), '\n'), chr(12), '\f'), chr(13), '\r');
	    content := convert(content,'AL16UTF16');
	    content_length := length(content);
	    RAISE NOTICE 'Params: %', content;
	    RAISE NOTICE 'Content-Length: %', content_length;
	
	    -- Config the request
	    RAISE NOTICE 'Configuring the request...';
	    request := utl_http.begin_request(url,'POST',' HTTP/1.1');
	    utl_http.set_header(request,'Content-Type','application/json');
	    utl_http.set_header(request,'Content-Length',content_length);
	    utl_http.write_text(request,content);
	
	    RAISE NOTICE 'Sending the request...';
	    response := utl_http.get_response(request);
	    BEGIN
	        RAISE NOTICE 'Reading reponse...';
	        LOOP
	            utl_http.read_line(response,buffer,false);
	            return_value := buffer;
	            RAISE NOTICE 'Return value: %', return_value;
	        END LOOP;
	        utl_http.end_response(response);
	        RAISE NOTICE 'End requesting (normal)...';
	    EXCEPTION
	        WHEN utl_http.end_of_body THEN
	            utl_http.end_response(response);
	            RAISE NOTICE 'End requesting (end_of_body)...';
	        WHEN utl_http.too_many_requests THEN
	            utl_http.end_response(response);
	            RAISE NOTICE 'End requesting (too_many_requests)...';
	    END;
	ELSE
		RAISE NOTICE 'Need to set the parameter: Java server address for database procedures.';
	END IF;
	
	RAISE NOTICE 'Finished call_java_ws.';
	RETURN return_value;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION call_java_ws ( endpoint text, params params_java_ws_pck.param_tab, ds_key text default '', ds_value text default '') FROM PUBLIC;

