-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_util_pck.obter_valor_tag ( ds_conteudo_p w_pls_monitor_ans_qualid.ds_xml%type, ds_tag_p text) RETURNS varchar AS $body$
DECLARE


ds_tag_inicio_w		varchar(255);
ds_tag_final_w		varchar(255);
ds_conteudo_tag_w	varchar(255);
qt_inicial_w		bigint;
qt_final_w		bigint;


BEGIN
--Obtem o inicio e o fim da tag
ds_tag_inicio_w := ds_tag_p;
ds_tag_final_w := '</' || substr(ds_tag_p, 2, length(ds_tag_p));

-- Obtem a posição inicial e final da tag dentro do trecho de XML passado de parâmetro
qt_inicial_w := position(ds_tag_inicio_w in ds_conteudo_p) + length(ds_tag_p);
qt_final_w := position(ds_tag_final_w in ds_conteudo_p) - qt_inicial_w;

-- Obtem o conteúdo da tag informada
ds_conteudo_tag_w := substr(ds_conteudo_p, qt_inicial_w, qt_final_w);

return ds_conteudo_tag_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_util_pck.obter_valor_tag ( ds_conteudo_p w_pls_monitor_ans_qualid.ds_xml%type, ds_tag_p text) FROM PUBLIC;
