-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_shoppingcart_gastherapy (nr_sequencia_p bigint, ie_retrogrado_p text, ds_retorno_p INOUT text) AS $body$
DECLARE


ie_continuo_w	varchar(1) := 'N';
ie_return_value_w	varchar(1);
qt_count_w	bigint;
qt_max_permitida_w	regra_unidade_gas.qt_max_permitida%type;

c01 CURSOR FOR
SELECT  a.*, obter_setor_atendimento(nr_atendimento) cd_setor_atend
from 	cpoe_gasoterapia a
where	nr_sequencia = nr_sequencia_p;

BEGIN
ds_retorno_p := 'S';

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	for r_c01_w in C01
	loop
		/* CAMPOS OBRIGATORIOS*/

		
		if (coalesce(r_c01_w.ie_respiracao::text, '') = '' or coalesce(r_c01_w.nr_seq_gas::text, '') = '' or coalesce(r_c01_w.cd_intervalo::text, '') = '' or coalesce(r_c01_w.qt_gasoterapia::text, '') = ''
			or coalesce(r_c01_w.qt_gasoterapia::text, '') = '' or coalesce(r_c01_w.dt_inicio::text, '') = '' or coalesce(r_c01_w.ie_administracao::text, '') = '' or coalesce(r_c01_w.ie_duracao::text, '') = '') then
			ds_retorno_p := 'N';
			goto return_value;
		end if;
	
		if (cpoe_shoppingcart_vigencia(r_c01_w.cd_intervalo, r_c01_w.ie_administracao, r_c01_w.dt_inicio,
				r_c01_w.ie_urgencia, r_c01_w.ie_duracao,r_c01_w.dt_fim, r_c01_w.ie_evento_unico, ie_retrogrado_p) = 'S') then
			ds_retorno_p := 'N';
			goto return_value;
		end if;
	
		/* FIM CAMPOS OBRIGATORIOS*/
	
		
		/* OPEN DETAIL*/

		
		if (r_c01_w.ie_modo_adm <> 'C' and r_c01_w.ie_administracao <> 'C' and coalesce(r_c01_w.qt_hora_fase::text, '') = '') then
			ds_retorno_p := 'N';
			goto return_value;
		end if;

		select	coalesce(max(ie_obriga_modalidade),'N') ie_obriga_modalidade
		into STRICT	ie_return_value_w
		from	regra_obriga_campo_gas
		where	cd_perfil =  coalesce(wheb_usuario_pck.get_cd_perfil, 0);

		select	count(*) qt
		into STRICT	qt_count_w
		from	modalidade_ventilatoria
		where	ie_respiracao = r_c01_w.ie_respiracao
		and	coalesce(ie_situacao,'A') = 'A';

		if (qt_count_w > 0 and ie_return_value_w = 'S' and coalesce(r_c01_w.cd_modalidade_vent::text, '') = '') then
			ds_retorno_p := 'N';
			goto return_value;
		end if;
		
		
		/* FIM OPEN DETAIL*/

		
		/* CUSTOM VALIDATOR */

		
		if (((r_c01_w.cd_mat_equip1 IS NOT NULL AND r_c01_w.cd_mat_equip1::text <> '') and (coalesce(r_c01_w.qt_dose_mat1,0) = 0 or coalesce(r_c01_w.cd_unid_med_dose1::text, '') = ''))
				or ((r_c01_w.cd_mat_equip2 IS NOT NULL AND r_c01_w.cd_mat_equip2::text <> '') and (coalesce(r_c01_w.qt_dose_mat2,0) = 0 or coalesce(r_c01_w.cd_unid_med_dose2::text, '') = ''))
				or ((r_c01_w.cd_mat_equip3 IS NOT NULL AND r_c01_w.cd_mat_equip3::text <> '') and (coalesce(r_c01_w.qt_dose_mat3,0) = 0 or coalesce(r_c01_w.cd_unid_med_dose3::text, '') = ''))
				or ((r_c01_w.ie_respiracao IS NOT NULL AND r_c01_w.ie_respiracao::text <> '') and (coalesce(r_c01_w.qt_gasoterapia,0) = 0))) then
			ds_retorno_p := 'N';
			goto return_value;
		end if;
		
		/* FIM CUSTOM VALIDATOR*/

		
		/* INCONSISTENCIA DA CPOE BARRA VERMELHA*/

		if (r_c01_w.dt_fim IS NOT NULL AND r_c01_w.dt_fim::text <> '') then
			ie_continuo_w := 'S';
		end if;
		
		/*DUPLICIDADE*/

		select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END  ie_duplicado
		into STRICT	ie_return_value_w
		from	cpoe_gasoterapia a
		where	a.nr_sequencia <> r_c01_w.nr_sequencia
		and		((nr_atendimento = r_c01_w.nr_atendimento) or (cd_pessoa_fisica = r_c01_w.cd_pessoa_fisica and coalesce(nr_atendimento::text, '') = ''))
		and		a.ie_respiracao  = r_c01_w.ie_respiracao
		and		a.nr_seq_gas = r_c01_w.nr_seq_gas
		and		(((dt_lib_suspensao IS NOT NULL AND dt_lib_suspensao::text <> '') and (dt_suspensao > clock_timestamp())) or (coalesce(dt_lib_suspensao::text, '') = ''))
		and 	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or (nm_usuario = wheb_usuario_pck.get_nm_usuario))
		and		obter_se_cpoe_regra_duplic('G', wheb_usuario_pck.get_cd_perfil, r_c01_w.cd_setor_atend) = 'S'
		and 	((a.dt_inicio between r_c01_w.dt_inicio and r_c01_w.dt_fim) or (a.dt_fim between r_c01_w.dt_inicio and r_c01_w.dt_fim) or (coalesce(a.dt_fim::text, '') = '' and a.dt_inicio < r_c01_w.dt_inicio) or (a.dt_fim > r_c01_w.dt_fim and a.dt_inicio < r_c01_w.dt_inicio) or	
				 (((a.dt_inicio >  r_c01_w.dt_inicio) and (coalesce(ie_continuo_w,'N') = 'S')) or ((coalesce(ie_continuo_w,'N') = 'N') and (r_c01_w.dt_inicio <= a.dt_inicio)  and r_c01_w.dt_fim > a.dt_inicio)) or (a.ie_retrogrado = 'S' and coalesce(a.dt_liberacao::text, '') = ''));

		if (ie_return_value_w = 'S') then
			ds_retorno_p := 'N';
			goto return_value;
		end if;
	
		/*LATEX*/

		if (cpoe_shoppingcart_se_latex(r_c01_w.cd_mat_equip1, r_c01_w.cd_pessoa_fisica) = 'S'
			or cpoe_shoppingcart_se_latex(r_c01_w.cd_mat_equip2, r_c01_w.cd_pessoa_fisica) = 'S'
			or cpoe_shoppingcart_se_latex(r_c01_w.cd_mat_equip3, r_c01_w.cd_pessoa_fisica) = 'S') then
			ds_retorno_p := 'N';
			goto return_value;
		end if;

		if (r_c01_w.nr_seq_gas IS NOT NULL AND r_c01_w.nr_seq_gas::text <> '') then

			select	coalesce(max(qt_max_permitida),0)
			into STRICT	qt_max_permitida_w
			from	regra_unidade_gas
			where	nr_seq_gas = r_c01_w.nr_seq_gas
			and 	ie_disp_resp_esp = r_c01_w.ie_disp_resp_esp
			and	ie_unidade_medida = r_c01_w.ie_unidade_medida;			

			if (qt_max_permitida_w <> 0) and (qt_max_permitida_w < r_c01_w.qt_gasoterapia) then
				ds_retorno_p := 'N';
				goto return_value;
			end if;
		end if;
		
		/* FIM INCONSISTENCIA DA CPOE BARRA VERMELHA*/

	end loop;
end if;

<<return_value>>		
 null;
exception when others then
	CALL gravar_log_cpoe(substr('CPOE_SHOPPINGCART_GASTHERAPY EXCEPTION:'|| substr(to_char(sqlerrm),1,2000) || '//nr_sequencia_p: '|| nr_sequencia_p,1,40000));
	ds_retorno_p := 'N';
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_shoppingcart_gastherapy (nr_sequencia_p bigint, ie_retrogrado_p text, ds_retorno_p INOUT text) FROM PUBLIC;

