-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_exame_ultimo_resultado ( nr_sequencia_p bigint, ie_tipo_lote_p text, ie_tipo_exame_p text) RETURNS varchar AS $body$
DECLARE


/*
IE_TIPO_LOTE_P
'D' - Exames de Doação
'R' - Exames da Reserva
'T' - Exames da Transfusão

IE_TIPO_EXAME_P
'ABO' -  Tipagem sanguínea, sistema ABO
'RH' - Fator Rh
'PAI' - Pesquisa de Anticorpos Irregulares
'HS' - Hemoglobina S
*/
ds_retorno_w		varchar(255);
nr_seq_exame_lote_w	san_exame_lote.nr_sequencia%type;
nr_seq_exame_w		san_exame.nr_sequencia%type;


BEGIN

	select	max(nr_sequencia)
	into STRICT	nr_seq_exame_lote_w
	from (SELECT	max(nr_sequencia) nr_sequencia
		from	san_exame_lote
		where	ie_tipo_lote_p	= 'D'
		and	nr_seq_doacao	= nr_sequencia_p
		
union

		SELECT	max(nr_sequencia) nr_sequencia
		from	san_exame_lote
		where	ie_tipo_lote_p	= 'R'
		and	nr_seq_reserva	= nr_sequencia_p
		
union

		select	max(nr_sequencia) nr_sequencia
		from	san_exame_lote
		where	ie_tipo_lote_p	  = 'T'
		and	nr_seq_transfusao = nr_sequencia_p) alias4;

	if (nr_seq_exame_lote_w IS NOT NULL AND nr_seq_exame_lote_w::text <> '') then

		select	max(nr_sequencia)
		into STRICT	nr_seq_exame_w
		from (SELECT	max(nr_sequencia) nr_sequencia
			from	san_exame
			where	ie_tipo_exame_p = 'ABO'
			and	ie_tipo_sangue	= 'S'
			and	ie_situacao	= 'A'
			
union

			SELECT	max(nr_sequencia) nr_sequencia
			from	san_exame
			where	ie_tipo_exame_p = 'RH'
			and	ie_fator_rh	= 'S'
			and	ie_situacao	= 'A'
			
union

			select	max(nr_sequencia) nr_sequencia
			from	san_exame
			where	ie_tipo_exame_p = 'PAI'
			and	ie_tipo_exame	= '2'
			and	ie_situacao	= 'A'
			
union

			select	max(nr_sequencia) nr_sequencia
			from	san_exame
			where	ie_tipo_exame_p = 'HS'
			and	ie_tipo_exame	= '8'
			and	ie_situacao	= 'A') alias6;

		if (nr_seq_exame_w IS NOT NULL AND nr_seq_exame_w::text <> '') then

			select 	coalesce(CASE WHEN b.ie_resultado='N' THEN  to_char(a.vl_resultado)  ELSE coalesce(CASE WHEN coalesce(c.cd_exp_valor_dominio::text, '') = '' THEN  a.ds_resultado  ELSE obter_desc_expressao(c.cd_exp_valor_dominio) END , a.ds_resultado) END , a.ie_resultado)
			into STRICT	ds_retorno_w
			from	san_exame b
			left join san_exame_realizado a
				on  a.nr_seq_exame		= b.nr_sequencia
			left join valor_dominio c
				on  	b.cd_tipo_resultado 	= c.cd_dominio
				and 	Upper(a.ds_resultado)	= Upper(c.ds_valor_dominio)
				and 	c.ie_situacao 		= 'A'
			where 	a.nr_seq_exame_lote	= nr_seq_exame_lote_w
			and 	a.nr_seq_exame		= nr_seq_exame_w
			and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '');

		end if;

	end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_exame_ultimo_resultado ( nr_sequencia_p bigint, ie_tipo_lote_p text, ie_tipo_exame_p text) FROM PUBLIC;

