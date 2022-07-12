-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_titulos_negociados (nr_seq_negociacao_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w      varchar(4000) := Wheb_mensagem_pck.get_texto(297742) || ' ';
nr_titulo_w       varchar(4000);
ds_data_venc_w     timestamp;
-- Essa function é utilizada para o parametro 19 da funcao Negociacao de Contas a Receber, para a observacao do titulo. 
C01 CURSOR FOR
    SELECT a.nr_titulo, 
        substr(obter_dados_titulo_receber(a.nr_titulo,'D'),1,255) 
    from  titulo_rec_negociado a 
    where  a.nr_seq_negociacao   = nr_seq_negociacao_p 
    order by a.nr_titulo;


BEGIN 
 
open C01;
loop 
fetch C01 into 
    nr_titulo_w, 
    ds_data_venc_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
    begin 
    ds_retorno_w := ds_retorno_w || nr_titulo_w || ', ' || Wheb_mensagem_pck.get_texto(297743) || ' '|| to_char(ds_data_venc_w,'dd/mm/yyyy')||', ';
	exception 
	when others then 
	ds_retorno_w := null;
    end;
end loop;
close C01;
 
return substr(ds_retorno_w,1,4000);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_titulos_negociados (nr_seq_negociacao_p bigint) FROM PUBLIC;

