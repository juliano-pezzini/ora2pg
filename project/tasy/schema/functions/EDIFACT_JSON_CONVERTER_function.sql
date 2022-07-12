-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION edifact_json_converter (edifact_message_p text) RETURNS text AS $body$
DECLARE


ds_retorno_w text;
json_retorno_w philips_json;
json_segmentos_w philips_json_list;
json_elementos_w philips_json;
json_grupos_w philips_json;
ds_segmentos_w    lista_varchar_pck.tabela_varchar;
ds_elementos_w    lista_varchar_pck.tabela_varchar;
ds_grupos_w    lista_varchar_pck.tabela_varchar;
edifact_message_w	varchar(30000);
BEGIN

    json_retorno_w := philips_json();
    json_segmentos_w := philips_json_list();

    edifact_message_w := replace(edifact_message_p, '+++', '+ + +');
    edifact_message_w := replace(edifact_message_w, '++', '+ +');
    edifact_message_w := replace(edifact_message_w, ':::', ': : :');
    edifact_message_w := replace(edifact_message_w, '::', ': :');

    ds_segmentos_w := obter_lista_string2(edifact_message_w, chr(39));
	
	for i in 1..ds_segmentos_w.count loop
		if ((ds_segmentos_w(i) IS NOT NULL AND (ds_segmentos_w(i))::text <> '')) then
			ds_elementos_w := obter_lista_string2(ds_segmentos_w(i), '+');
            json_elementos_w := philips_json();
			for j in 1..ds_elementos_w.count loop
				if ((ds_elementos_w(j) IS NOT NULL AND (ds_elementos_w(j))::text <> '')) then
					if (ds_elementos_w(j) like '%:%') then
						ds_grupos_w := obter_lista_string2(ds_elementos_w(j), ':');
						json_grupos_w := philips_json();
						for k in 1..ds_grupos_w.count loop	
							if ((ds_grupos_w(k) IS NOT NULL AND (ds_grupos_w(k))::text <> '')) then
								json_grupos_w.put(to_char(k),ds_grupos_w(k));
							end if;
						end loop;
						json_elementos_w.put(to_char(j), json_grupos_w.to_json_value());
					else
						json_elementos_w.put(to_char(j),ds_elementos_w(j));
					end if;
				end if;
            end loop;	
			json_segmentos_w.append(json_elementos_w.to_json_value()); 		
		end if;
	end loop;
    json_retorno_w.put('EDIFACT', json_segmentos_w.to_json_value());
    dbms_lob.createtemporary(ds_retorno_w, true);
    json_retorno_w.(ds_retorno_w);
    return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION edifact_json_converter (edifact_message_p text) FROM PUBLIC;

