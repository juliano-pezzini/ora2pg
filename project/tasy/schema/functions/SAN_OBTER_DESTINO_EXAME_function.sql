-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_destino_exame (nr_seq_exame_p bigint, ie_destino_p bigint) RETURNS varchar AS $body$
DECLARE

ie_doacao_w		varchar(1);
ie_triagem_w		varchar(1);
ie_coleta_w		varchar(1);
ie_producao_w		varchar(1);
ie_reserva_w		varchar(1);
ie_transfusao_w		varchar(1);
ie_sangue_res_w		varchar(1);
ie_sangue_trans_w	varchar(1);
ie_emprestimo_w		varchar(1);
ie_exige_senha_w	varchar(1);

ds_retorno_w		varchar(1);

BEGIN

select	ie_doacao,
	ie_triagem,
	ie_coleta,
	ie_producao,
	ie_reserva,
	ie_transfusao,
	ie_sangue_res,
	ie_sangue_trans,
	ie_emprestimo,
	ie_exige_senha
into STRICT	ie_doacao_w,
	ie_triagem_w,
	ie_coleta_w,
	ie_producao_w,
	ie_reserva_w,
	ie_transfusao_w,
	ie_sangue_res_w,
	ie_sangue_trans_w,
	ie_emprestimo_w,
	ie_exige_senha_w
from	san_exame
where 	nr_sequencia = nr_seq_exame_p;

if (ie_destino_p = 0) and (ie_doacao_w = 'S') and (ie_exige_senha_w = 'N') and (ie_triagem_w = 'N') and (ie_coleta_w = 'N') then
	ds_retorno_w := 'S';
elsif (ie_destino_p = 1) and (ie_triagem_w = 'S') then
	ds_retorno_w := 'S';
elsif (ie_destino_p = 2) and (ie_coleta_w = 'S') then
	ds_retorno_w := 'S';
elsif (ie_destino_p = 3) and (ie_exige_senha_w = 'S') then
	ds_retorno_w := 'S';
elsif (ie_destino_p = 4) and (ie_producao_w = 'S') then
	ds_retorno_w := 'S';
elsif (ie_destino_p = 5) and (ie_reserva_w = 'S') then
	ds_retorno_w := 'S';
elsif (ie_destino_p = 6) and (ie_emprestimo_w = 'S') then
	ds_retorno_w := 'S';
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_destino_exame (nr_seq_exame_p bigint, ie_destino_p bigint) FROM PUBLIC;

