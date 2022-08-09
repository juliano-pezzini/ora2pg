-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_shoppingcart_recomend (nr_sequencia_p bigint, ie_retrogrado_p text, ds_retorno_p INOUT text) AS $body$
DECLARE


ie_continuo_w		varchar(1) := 'N';
ie_return_value_w	varchar(1);
ie_alterar_interv_w	tipo_recomendacao.ie_alterar_interv%type;
ie_questionar_topografia_w	tipo_recomendacao.ie_questionar_topografia%type;
					
c01 CURSOR FOR
SELECT  a.*, obter_setor_atendimento(nr_atendimento) cd_setor_atend
from 	cpoe_recomendacao a
where	nr_sequencia = nr_sequencia_p;

BEGIN

ds_retorno_p := 'S';

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	<<check_item>>
	for r_c01_w in C01
	loop

		/* CAMPOS OBRIGATORIOS */

		if (coalesce(r_c01_w.cd_recomendacao::text, '') = '' or coalesce(r_c01_w.dt_inicio::text, '') = ''
			or coalesce(r_c01_w.ie_administracao::text, '') = '' or coalesce(r_c01_w.ie_duracao::text, '') = '') then
			ds_retorno_p := 'N';
			exit check_item;
		end if;
		
		select	coalesce(max(ie_alterar_interv),'S') ie_alterar_interv,
				coalesce(max(ie_questionar_topografia),'N') ie_questionar_topografia
		into STRICT	ie_alterar_interv_w,
				ie_questionar_topografia_w
		from	tipo_recomendacao
		where	cd_tipo_recomendacao = r_c01_w.cd_recomendacao;

		if (coalesce(r_c01_w.cd_intervalo::text, '') = '' and ie_alterar_interv_w = 'S') then
			ds_retorno_p := 'N';
			exit check_item;
		end if;

		if (coalesce(r_c01_w.nr_seq_topografia::text, '') = '' and ie_questionar_topografia_w = 'S') then
			ds_retorno_p := 'N';
			exit check_item;
		end if;

		if (cpoe_shoppingcart_vigencia(r_c01_w.cd_intervalo, r_c01_w.ie_administracao, r_c01_w.dt_inicio,
								r_c01_w.ie_urgencia, r_c01_w.ie_duracao,r_c01_w.dt_fim, r_c01_w.ie_evento_unico, ie_retrogrado_p) = 'S') then
			ds_retorno_p := 'N';
			exit check_item;
		end if;
				
		/* FIM CAMPOS OBRIGATORIOS */



		/* INCONSISTENCIA DA CPOE (BARRA VERMELHA) */

	
		if (r_c01_w.dt_fim IS NOT NULL AND r_c01_w.dt_fim::text <> '') then
			ie_continuo_w := 'S';
		end if;
		
		/*DUPLICIDADE*/

		select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END  ie_duplicado
		into STRICT	ie_return_value_w
		from	cpoe_recomendacao a
		where	a.nr_sequencia <> r_c01_w.nr_sequencia
		and		obter_se_cpoe_regra_duplic('R', wheb_usuario_pck.get_cd_perfil, r_c01_w.cd_setor_atend) = 'S' 
		and		((nr_atendimento = r_c01_w.nr_atendimento) or (cd_pessoa_fisica = r_c01_w.cd_pessoa_fisica and coalesce(nr_atendimento::text, '') = ''))
		and		((cpoe_reg_valido_ativacao( CASE WHEN coalesce(dt_lib_suspensao::text, '') = '' THEN  dt_fim  ELSE coalesce(dt_suspensao,dt_fim) END , dt_inicio, clock_timestamp()) = 'S') or (ie_retrogrado = 'S' and coalesce(dt_liberacao::text, '') = ''))
		and		a.cd_recomendacao = r_c01_w.cd_recomendacao
		and		((dt_lib_suspensao IS NOT NULL AND dt_lib_suspensao::text <> '' AND dt_suspensao > r_c01_w.dt_inicio) or (coalesce(dt_lib_suspensao::text, '') = ''))
		and 	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or (nm_usuario = wheb_usuario_pck.get_nm_usuario))
		and 	((a.dt_inicio between r_c01_w.dt_inicio and r_c01_w.dt_fim) or (a.dt_fim between r_c01_w.dt_inicio and r_c01_w.dt_fim) or (coalesce(a.dt_fim::text, '') = '' and a.dt_inicio < r_c01_w.dt_inicio) or (a.dt_fim > r_c01_w.dt_fim and a.dt_inicio < r_c01_w.dt_inicio) or	
				 (((a.dt_inicio >  r_c01_w.dt_inicio) and (coalesce(ie_continuo_w,'N') = 'S')) or ((coalesce(ie_continuo_w,'N') = 'N') and (r_c01_w.dt_inicio <= a.dt_inicio)  and r_c01_w.dt_fim > a.dt_inicio)) or (a.ie_retrogrado = 'S' and coalesce(a.dt_liberacao::text, '') = ''));

		if (ie_return_value_w = 'S') then
			ds_retorno_p := 'N';
			exit check_item;
		end if;
		
		/* FIM INCONSISTENCIA DA CPOE (BARRA VERMELHA) */

	end loop check_item;
end if;

exception when others then
	CALL gravar_log_cpoe(substr('CPOE_SHOPPINGCART_RECOMEND EXCEPTION:'|| substr(to_char(sqlerrm),1,2000) || '//nr_sequencia_p: '|| nr_sequencia_p,1,40000));
	ds_retorno_p := 'N';
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_shoppingcart_recomend (nr_sequencia_p bigint, ie_retrogrado_p text, ds_retorno_p INOUT text) FROM PUBLIC;
