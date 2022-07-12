-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obt_prova_compatibilidade ( nr_sequencia_p bigint, ie_opcao_p text, cd_exame_p bigint) RETURNS varchar AS $body$
DECLARE

/*
nr_sequencia_p	-> Sequencia da reservar ou transfusao
ie_opcao_p		-> R - Reserva     ou     T - Transfusao
		ER - Resultado do exame da prova de compatibilidade da pasta Reserva
		ET -       ||             ||          ||                   ||               ||  Transfusao

cd_exame_p		-> Sequencia do exame da tabela SAN_EXAME
*/
ds_retorno_w	varchar(100);


BEGIN
if (ie_opcao_p = 'R') then
	select	count(*)
	into STRICT	ds_retorno_w
	from  	san_exame a,
		san_exame_lote b,
		san_exame_realizado c
	where	a.nr_sequencia = c.nr_seq_exame
	and	b.nr_sequencia = c.nr_seq_exame_lote
	and	upper(c.ds_resultado) = 'POSITIVO'
	and	a.ie_tipo_exame = 1
	and	(( b.nr_seq_reserva = nr_sequencia_p)
		or	exists (SELECT	1
				from	san_reserva_prod x
				where	x.nr_seq_reserva  = nr_sequencia_p
				and	b.nr_seq_res_prod = x.nr_sequencia));
elsif (ie_opcao_p = 'T') then
	select	count(*)
	into STRICT	ds_retorno_w
	from  	san_exame a,
		san_exame_lote b,
		san_exame_realizado c
	where	a.nr_sequencia = c.nr_seq_exame
	and	b.nr_sequencia = c.nr_seq_exame_lote
	and	upper(c.ds_resultado) = 'POSITIVO'
	and	a.ie_tipo_exame = 1
	and	b.nr_seq_transfusao = nr_sequencia_p;
elsif (ie_opcao_p = 'ER') then
	select	c.ds_resultado
	into STRICT	ds_retorno_w
	from	san_exame a,
		san_exame_lote b,
		san_exame_realizado c
	where	a.nr_sequencia = cd_exame_p
	and	b.nr_seq_reserva = nr_sequencia_p
	and	a.nr_sequencia = c.nr_seq_exame
	and	b.nr_sequencia = c.nr_seq_exame_lote;
elsif (ie_opcao_p = 'ET') then
	select	c.ds_resultado
	into STRICT	ds_retorno_w
	from	san_exame a,
		san_exame_lote b,
		san_exame_realizado c
	where	a.nr_sequencia = cd_exame_p
	and	b.nr_seq_transfusao = nr_sequencia_p
	and	a.nr_sequencia = c.nr_seq_exame
	and	b.nr_sequencia = c.nr_seq_exame_lote;
end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obt_prova_compatibilidade ( nr_sequencia_p bigint, ie_opcao_p text, cd_exame_p bigint) FROM PUBLIC;
