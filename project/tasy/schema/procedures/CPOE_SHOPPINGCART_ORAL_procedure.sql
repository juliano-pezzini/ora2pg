-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_shoppingcart_oral ( nr_sequencia_p bigint, ie_retrogrado_p text, ds_retorno_p INOUT text) AS $body$
DECLARE


qt_count_w			bigint;
ie_return_value_w		varchar(1);
ie_continuo_w			varchar(1);
ie_continuo_ww			varchar(1);
ie_questiona_intervalo_w	dieta.ie_questiona_intervalo%type;
ie_consiste_jejum_w		varchar(1);
nm_usuario_w			usuario.nm_usuario%type;
ie_paciente_jejum_w		varchar(1);
dt_fim_w			cpoe_dieta.dt_fim%type;

c01 CURSOR FOR
SELECT	a.*, obter_setor_atendimento(nr_atendimento) cd_setor_atend
from 	cpoe_dieta a
where	nr_sequencia = nr_sequencia_p;

BEGIN

nm_usuario_w := wheb_usuario_pck.get_nm_usuario;

ds_retorno_p := 'S';

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	for r_c01_w in C01
	loop
	
		/* CAMPOS OBRIGATORIOS */

		if (coalesce(r_c01_w.cd_dieta::text, '') = '' or coalesce(r_c01_w.dt_inicio::text, '') = '' or coalesce(r_c01_w.ie_duracao::text, '') = '') then
			ds_retorno_p := 'N';
			goto return_value;
		end if;

		select 	 coalesce(max(ie_questiona_intervalo), 'N')
		into STRICT	ie_questiona_intervalo_w
		from 	dieta
		where 	cd_dieta = r_c01_w.cd_dieta;
		
		if (ie_questiona_intervalo_w = 'S' and coalesce(r_c01_w.cd_intervalo::text, '') = '') then
			ds_retorno_p := 'N';
			goto return_value;
		end if;
					
		if (cpoe_shoppingcart_vigencia(r_c01_w.cd_intervalo, 'P', r_c01_w.dt_inicio,
								r_c01_w.ie_urgencia, r_c01_w.ie_duracao,r_c01_w.dt_fim, r_c01_w.ie_evento_unico, ie_retrogrado_p) = 'S') then
			ds_retorno_p := 'N';
			goto return_value;
		end if;

		/* FIM CAMPOS OBRIGATORIOS */
	

		/* INCONSISTENCIA DA CPOE (BARRA VERMELHA) */

		
		if (r_c01_w.dt_fim IS NOT NULL AND r_c01_w.dt_fim::text <> '') then
			ie_continuo_w := 'S';
		end if;
		
		if (coalesce(ie_continuo_w,'N') <> 'S') then
			dt_fim_w := r_c01_w.dt_inicio + 1;
		else
			dt_fim_w := r_c01_w.dt_fim;
		end if;

		/*Duplicidade*/

		select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END  ie_duplicado
		into STRICT	ie_return_value_w
		from	cpoe_dieta a
		where	a.nr_sequencia <> r_c01_w.nr_sequencia
		and		obter_se_cpoe_regra_duplic('O', wheb_usuario_pck.get_cd_perfil, r_c01_w.cd_setor_atend) = 'S'
		and		((nr_atendimento = r_c01_w.nr_atendimento) or (cd_pessoa_fisica = r_c01_w.cd_pessoa_fisica and coalesce(nr_atendimento::text, '') = ''))
		and		a.cd_dieta = r_c01_w.cd_dieta
		and		a.ie_tipo_dieta = 'O'
		and		(((dt_lib_suspensao IS NOT NULL AND dt_lib_suspensao::text <> '') and (dt_suspensao > clock_timestamp())) or (coalesce(dt_lib_suspensao::text, '') = ''))
		and 	((dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') or (nm_usuario = nm_usuario_w))
		and 	((a.dt_inicio between r_c01_w.dt_inicio and dt_fim_w) or (a.dt_fim between r_c01_w.dt_inicio and dt_fim_w) or (coalesce(a.dt_fim::text, '') = '' and a.dt_inicio < r_c01_w.dt_inicio) or (a.dt_fim > dt_fim_w and a.dt_inicio < r_c01_w.dt_inicio) or	
				 (((a.dt_inicio >  r_c01_w.dt_inicio) and (coalesce(ie_continuo_w,'N') = 'S')) or ((coalesce(ie_continuo_w,'N') = 'N') and (r_c01_w.dt_inicio <= a.dt_inicio)  and dt_fim_w > a.dt_inicio)) or (a.ie_retrogrado = 'S' and coalesce(a.dt_liberacao::text, '') = ''));

		if (ie_return_value_w = 'S') then
			ds_retorno_p := 'N';
			goto return_value;
		end if;

		/*Interacao farmaco x nutricao*/

		select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END  ie_duplicado
		into STRICT	ie_return_value_w	
		from	medic_interacao_alimento a
		where	cd_dieta = r_c01_w.cd_dieta
		and	a.cd_material in (	SELECT a.cd_material
								from	cpoe_material_vig_v a
								where	((a.nr_atendimento = r_c01_w.nr_atendimento) or (a.cd_pessoa_fisica = r_c01_w.cd_pessoa_fisica and coalesce(a.nr_atendimento::text, '') = ''))
								and	((cpoe_reg_valido_ativacao( a.dt_fim,a.dt_inicio, clock_timestamp()) = 'S') or (a.ie_retrogrado = 'S' and coalesce(a.dt_liberacao::text, '') = ''))
								and	((a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '') or (a.nm_usuario = nm_usuario_w))
								and	a.ie_tipo_item in ('MAT','MCOMP1','MCOMP2','MCOMP3', 'PMAT1', 'PMAT2', 'PMAT3', 'PMAT4', 'PMAT5', 'GMAT1', 'GMAT2', 'GMAT3')
								and coalesce(a.dt_fim_item, clock_timestamp() + interval '1 days') > (clock_timestamp() - (select coalesce(nr_dias_interacao,0) from parametro_medico where cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento)));

		if (ie_return_value_w = 'S') then
			ds_retorno_p := 'N';
			goto return_value;
		end if;

		/* FIM INCONSISTENCIA DA CPOE (BARRA VERMELHA) */

		

		ie_consiste_jejum_w := Obter_param_Usuario(924, 708, obter_perfil_ativo, nm_usuario_w, wheb_usuario_pck.get_cd_estabelecimento, ie_consiste_jejum_w);

		if (coalesce(ie_consiste_jejum_w,'N') = 'S') then

			ie_continuo_ww := 'N';
			dt_fim_w       := r_c01_w.dt_fim;	
		
			if (coalesce(r_c01_w.dt_fim::text, '') = '') then
				ie_continuo_ww := 'S';
				dt_fim_w := clock_timestamp() + interval '1 days';
			end if;

			select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END  ie_paciente_jejum
			into STRICT 	ie_paciente_jejum_w
			from	cpoe_dieta
			where	((nr_atendimento = r_c01_w.nr_atendimento) or (cd_pessoa_fisica = r_c01_w.cd_pessoa_fisica and coalesce(nr_atendimento::text, '') = ''))		
			and	ie_tipo_dieta = 'J'
			and	(((dt_lib_suspensao IS NOT NULL AND dt_lib_suspensao::text <> '') and 
				  dt_suspensao > clock_timestamp()) or 
				 coalesce(dt_lib_suspensao::text, '') = '')
			and	((dt_inicio between r_c01_w.dt_inicio and dt_fim_w) or (coalesce(dt_suspensao,dt_fim) between r_c01_w.dt_inicio and dt_fim_w) or (coalesce(dt_fim::text, '') = '' and 
				  coalesce(dt_suspensao::text, '') = '' and 
				  dt_inicio < r_c01_w.dt_inicio) or (coalesce(dt_suspensao,dt_fim) > dt_fim_w and 
				  dt_inicio < r_c01_w.dt_inicio) or
				 ((dt_inicio >  r_c01_w.dt_inicio and 
				   coalesce(ie_continuo_w,'N') = 'S') or (coalesce(ie_continuo_w,'N') = 'N' and 
				   r_c01_w.dt_inicio <= dt_inicio and 
				   dt_fim_w > dt_inicio)) or (ie_retrogrado = 'S' and coalesce(dt_liberacao::text, '') = ''))
			and 	((nm_usuario_nrec <> nm_usuario_w and (dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')) or 
				 nm_usuario_nrec = nm_usuario_w);

			if (ie_paciente_jejum_w = 'S') then
				ds_retorno_p := 'N';
				goto return_value;
			end if;
		end if;
	end loop;
end if;

<<return_value>>
 null;
exception when others then
	CALL gravar_log_cpoe(substr('CPOE_SHOPPINGCART_ORAL EXCEPTION:'|| substr(to_char(sqlerrm),1,2000) || '//nr_sequencia_p: '|| nr_sequencia_p,1,40000));
	ds_retorno_p := 'N';
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_shoppingcart_oral ( nr_sequencia_p bigint, ie_retrogrado_p text, ds_retorno_p INOUT text) FROM PUBLIC;
