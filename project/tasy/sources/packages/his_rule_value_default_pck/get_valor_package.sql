-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION his_rule_value_default_pck.get_valor ( nm_tabela_p tabela_atributo.nm_tabela%type, nm_atributo_p tabela_atributo.nm_atributo%type, ie_aparelho_pa_p atendimento_sinal_vital.ie_aparelho_pa%type, nr_seq_template_p ehr_template.nr_sequencia%type, nr_seq_elemento_p ehr_template_conteudo.nr_sequencia%type) RETURNS SETOF T_VALUE_TABLE AS $body$
DECLARE

			
	row_w				t_value_row;
	ds_resultado_w		varchar(4000);
	vl_resultado_w		double precision;
	dt_resultado_w		timestamp;
	dt_inicio_w			timestamp;
	ie_modo_busca_w		his_rule_value_default.ie_modo_busca%type;
	ie_tempo_busca_w	his_rule_value_default.ie_tempo_busca%type;
	nr_tempo_busca_w	his_rule_value_default.nr_tempo_busca%type;
	eh_template_w		boolean;
	cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
	
BEGIN
	cd_estabelecimento_w	:=	wheb_usuario_pck.get_cd_estabelecimento;

	eh_template_w			:= (nr_seq_template_p IS NOT NULL AND nr_seq_template_p::text <> '');
	
	if (eh_template_w) then
		select	max(ie_modo_busca),
				max(ie_tempo_busca),
				max(nr_tempo_busca)
		into STRICT	ie_modo_busca_w,
				ie_tempo_busca_w,
				nr_tempo_busca_w
		from	his_rule_value_default
		where	cd_estabelecimento 	=	cd_estabelecimento_w
		and		nr_seq_template 	= 	nr_seq_template_p
		and		nr_seq_elemento 	= 	nr_seq_elemento_p;
	else	
		SELECT ie_modo_busca,
				ie_tempo_busca,
				nr_tempo_busca
    INTO STRICT	ie_modo_busca_w,
				ie_tempo_busca_w,
				nr_tempo_busca_w
    FROM ( SELECT	*
      from	his_rule_value_default
      where	cd_estabelecimento 				=	cd_estabelecimento_w
      and		nm_tabela 						= 	nm_tabela_p
      and		nm_atributo 					= 	nm_atributo_p
      and		coalesce(ie_aparelho_pa,'C')	=	coalesce(ie_aparelho_pa_p,'C')
      order by nr_seq_template) alias2 LIMIT 1;
	end if;	
	
	if (ie_tempo_busca_w IS NOT NULL AND ie_tempo_busca_w::text <> '') then
		case ie_tempo_busca_w
			when	'D'	then --Dias
				dt_inicio_w	:=	clock_timestamp()	- nr_tempo_busca_w;
			when	'H'	then --Horas
				dt_inicio_w	:=	clock_timestamp()	- (nr_tempo_busca_w/24);
			when	'M'	then --Minutos
				dt_inicio_w	:=	clock_timestamp()	- (nr_tempo_busca_w/1440);
		end case;

		if (ie_modo_busca_w = 'P') then
			begin
			if (eh_template_w) then
				select	min(ds_resultado),
						min(vl_resultado),
						min(dt_resultado)
				into STRICT	ds_resultado_w,
						vl_resultado_w,
						dt_resultado_w
				from	table(get_dados)
				where	nr_seq_template	= nr_seq_template_p
				and		nr_seq_elemento	= nr_seq_elemento_p
        			and   coalesce(ie_modo_busca::text, '') = ''
				and		dt_registro	= (	SELECT	min(dt_registro)
										from	table(get_dados)
										where	nr_seq_template = nr_seq_template_p
										and		nr_seq_elemento	= nr_seq_elemento_p
                    and   coalesce(ie_modo_busca::text, '') = ''
										and		dt_registro	between	dt_inicio_w and clock_timestamp());
			else
				select	min(ds_resultado),
						min(vl_resultado),
						min(dt_resultado)
				into STRICT	ds_resultado_w,
						vl_resultado_w,
						dt_resultado_w
				from	table(get_dados)
				where	nm_tabela 						= nm_tabela_p
				and		nm_atributo 					= nm_atributo_p
				and		coalesce(ie_aparelho_pa,'C')	=	coalesce(ie_aparelho_pa_p,'C')
				and		dt_registro	= (	SELECT	min(dt_registro)
										from	table(get_dados)
										where	nm_tabela 						= 	nm_tabela_p
										and		nm_atributo 					= 	nm_atributo_p
										and		coalesce(ie_aparelho_pa,'C')	=	coalesce(ie_aparelho_pa_p,'C')
										and		dt_registro	between	dt_inicio_w and clock_timestamp());
			end if;							
			exception
			WHEN unique_violation THEN
				ds_resultado_w	:= null;
				vl_resultado_w	:= null;
				dt_resultado_w	:= null;
			end;
		elsif (ie_modo_busca_w = 'U' or ie_modo_busca_w = 'TA') then
			begin
			if (eh_template_w) then
				select	max(ds_resultado),
						max(vl_resultado),
						max(dt_resultado)
				into STRICT	ds_resultado_w,
						vl_resultado_w,
						dt_resultado_w
				from	table(get_dados)
				where	nr_seq_template	= nr_seq_template_p
				and		nr_seq_elemento	= nr_seq_elemento_p
				and		dt_registro	= (	SELECT	max(dt_registro)
										from	table(get_dados)
										where	nr_seq_template = nr_seq_template_p
										and		nr_seq_elemento	= nr_seq_elemento_p
										and		dt_registro	between	dt_inicio_w and clock_timestamp());
			else
				select	max(ds_resultado),
						max(vl_resultado),
						max(dt_resultado)
				into STRICT	ds_resultado_w,
						vl_resultado_w,
						dt_resultado_w
				from	table(get_dados)
				where	nm_tabela 						= nm_tabela_p
				and		nm_atributo 					= nm_atributo_p
				and		coalesce(ie_aparelho_pa,'C')	= coalesce(ie_aparelho_pa_p,'C')
       				and (ie_modo_busca = ie_modo_busca_w OR ie_modo_busca_w = 'U')
				and		dt_registro	= (	SELECT	max(dt_registro)
										from	table(get_dados)
										where	nm_tabela 						= nm_tabela_p
										and		nm_atributo 					= nm_atributo_p
										and		coalesce(ie_aparelho_pa,'C')	= coalesce(ie_aparelho_pa_p,'C')
                    and (ie_modo_busca = ie_modo_busca_w OR ie_modo_busca_w = 'U')
										and		dt_registro	between	dt_inicio_w and clock_timestamp());
			end if;							
			exception
			WHEN unique_violation THEN
				ds_resultado_w	:= null;
				vl_resultado_w	:= null;
				dt_resultado_w	:= null;
			end;
		elsif (ie_modo_busca_w = 'AA') then
			begin
			if (eh_template_w) then
				select	max(ds_resultado),
						max(vl_resultado),
						max(dt_resultado)
				into STRICT	ds_resultado_w,
						vl_resultado_w,
						dt_resultado_w
				from	table(get_dados)
				where	nr_seq_template	= nr_seq_template_p
				and		nr_seq_elemento	= nr_seq_elemento_p
				and		ie_modo_busca	= ie_modo_busca_w
				and		dt_registro	= (	SELECT	max(dt_registro)
										from	table(get_dados)
										where	nr_seq_template	= nr_seq_template_p
										and		nr_seq_elemento	= nr_seq_elemento_p
                    and		ie_modo_busca	= ie_modo_busca_w
										and		dt_registro	between	dt_inicio_w and clock_timestamp());
			else
				select	max(ds_resultado),
						max(vl_resultado),
						max(dt_resultado)
				into STRICT	ds_resultado_w,
						vl_resultado_w,
						dt_resultado_w
				from	table(get_dados)
				where	nm_tabela 						= nm_tabela_p
				and		nm_atributo 					= nm_atributo_p
				and		ie_modo_busca					= ie_modo_busca_w
				and		coalesce(ie_aparelho_pa,'C')	= coalesce(ie_aparelho_pa_p,'C')
				and		dt_registro	= (	SELECT	max(dt_registro)
										from	table(get_dados)
										where	nm_tabela 						= 	nm_tabela_p
										and		nm_atributo 					= 	nm_atributo_p
                    and		ie_modo_busca					=   ie_modo_busca_w
										and		coalesce(ie_aparelho_pa,'C')	=	coalesce(ie_aparelho_pa_p,'C')
										and		dt_registro	between	dt_inicio_w and clock_timestamp());
			end if;							
			exception
			WHEN unique_violation THEN
				ds_resultado_w	:= null;
				vl_resultado_w	:= null;
				dt_resultado_w	:= null;
			end;	
		end if;	
	
	row_w.ds_resultado			:= 	ds_resultado_w;
	row_w.vl_resultado			:= 	vl_resultado_w;
	row_w.dt_resultado			:= 	dt_resultado_w;
	RETURN NEXT row_w;
	end if;
	return;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 IMMUTABLE;
-- REVOKE ALL ON FUNCTION his_rule_value_default_pck.get_valor ( nm_tabela_p tabela_atributo.nm_tabela%type, nm_atributo_p tabela_atributo.nm_atributo%type, ie_aparelho_pa_p atendimento_sinal_vital.ie_aparelho_pa%type, nr_seq_template_p ehr_template.nr_sequencia%type, nr_seq_elemento_p ehr_template_conteudo.nr_sequencia%type) FROM PUBLIC;