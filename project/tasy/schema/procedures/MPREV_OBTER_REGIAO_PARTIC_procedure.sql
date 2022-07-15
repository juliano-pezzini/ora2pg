-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mprev_obter_regiao_partic ( nr_seq_participante_p bigint, dt_agendamento_p timestamp, ds_texto_p INOUT text, ds_cor_fonte_p INOUT text, ds_cor_fundo_p INOUT text) AS $body$
DECLARE


ds_cor_fundo_w		   mprev_area_atend_domic.ds_cor_fundo%type;
ds_cor_fonte_w		   mprev_area_atend_domic.ds_cor_fonte%type;
ds_area_w		   mprev_area_atend_domic.ds_area%type;


BEGIN

begin
	select	b.ds_cor_fundo,
		b.ds_cor_fonte,
		b.ds_area
	into STRICT	ds_cor_fundo_w,
		ds_cor_fonte_w,
		ds_area_w
	from	mprev_partic_tipo_atend a,
		mprev_area_atend_domic b
	where	a.nr_seq_area_atendimento  = b.nr_sequencia
	and	a.nr_seq_participante = nr_seq_participante_p
	and	trunc(dt_inicio) <= trunc(dt_agendamento_p)
	and (trunc(dt_fim) >= trunc(dt_agendamento_p) or coalesce(dt_fim::text, '') = '')  LIMIT 1;
exception
when others then
	ds_cor_fundo_w	:= null;
	ds_cor_fonte_w	:= null;
	ds_area_w := null;
end;

ds_texto_p := ds_area_w;
ds_cor_fonte_p := ds_cor_fonte_w;
ds_cor_fundo_p := ds_cor_fundo_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_obter_regiao_partic ( nr_seq_participante_p bigint, dt_agendamento_p timestamp, ds_texto_p INOUT text, ds_cor_fonte_p INOUT text, ds_cor_fundo_p INOUT text) FROM PUBLIC;

