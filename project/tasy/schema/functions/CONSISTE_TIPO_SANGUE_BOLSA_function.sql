-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION consiste_tipo_sangue_bolsa (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE



nr_seq_exame_rh_w      	bigint;
nr_seq_exame_tipo_w 	bigint;
ds_retorno_w		varchar(255) := 'S';
qtd_w			bigint;
nr_seq_lote_w		bigint;



BEGIN

nr_seq_exame_rh_w 	:= obter_valor_san_parametro('RH', wheb_usuario_pck.get_cd_estabelecimento);
nr_seq_exame_tipo_w 	:= obter_valor_san_parametro('TS', wheb_usuario_pck.get_cd_estabelecimento);

select 	max(nr_sequencia)
into STRICT	nr_seq_lote_w
from   	san_exame_lote
where  	nr_seq_reserva = nr_sequencia_p;

select 	count(*)
into STRICT	qtd_w
from   	san_exame_realizado
where  	nr_seq_exame_lote 	= nr_seq_lote_w
and	nr_seq_exame 	 	in (nr_seq_exame_rh_w, nr_seq_exame_tipo_w)
and	(ds_resultado IS NOT NULL AND ds_resultado::text <> '');

if (qtd_w < 2) then
	ds_retorno_w := wheb_mensagem_pck.get_texto(796615);
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION consiste_tipo_sangue_bolsa (nr_sequencia_p bigint) FROM PUBLIC;
