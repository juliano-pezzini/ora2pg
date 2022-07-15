-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_reaprazar_sae_regra_sv ( nr_seq_SV_p bigint, nm_usuario_p text) AS $body$
DECLARE


dt_nova_intervencao_w		timestamp;
dt_sinal_vital_w		timestamp;
nr_sequencia_pe_prescricao_w	bigint;
nr_sequencia_pe_prescr_proc_w	bigint;
nr_seq_prescr_w 	bigint;
qt_minima_w			double precision;
qt_maxima_w			double precision;
nr_seq_proc_w			bigint;			
qt_tempo_hor_regra_w		bigint;
nr_seq_sinal_vital_w		bigint;
nm_atributo_w			varchar(255);
qt_idade_w			double precision;
qt_idade_dia_w			double precision;
cd_pessoa_fisica_w		varchar(255);
cd_escala_dor_w			varchar(255);
qt_valor_SV_w			double precision;
cd_setor_Atendimento_w		integer;
nr_atendimento_w		bigint;
ie_inconsistencia_w		varchar(255);
ds_inconsistentes_w		varchar(4000);
ds_observacao_w			varchar(2000);
ds_sinal_vital_w		varchar(60);
ds_sinal_vital_total_w	varchar(2000);
ds_sinal_vital_intervencao_w varchar(2000);
qt_itens_associados_w		bigint;
ie_new_record_w			boolean := false;
cd_intervalo_w			varchar(7);
IE_PRIM_HORARIO_w		smallint;
dt_prim_horario_w		timestamp;
dt_prescricao_w			timestamp;
cd_estabelecimento_w	integer;
ie_faixa_w			varchar(1);


c01 CURSOR FOR
	SELECT	a.nr_sequencia,
		a.nm_atributo
	from	sinal_vital a
	where	exists (	SELECT	1
						from	sinal_vital_pe_proc x
						where	x.nr_seq_sinal = a.nr_sequencia);

c02 CURSOR FOR
	SELECT	b.qt_minima,
		b.qt_maxima,
		b.nr_seq_proc,
		b.qt_tempo_hor,
		coalesce( obter_expressao_idioma(CD_EXP_INFORMACAO,philips_param_pck.get_nr_seq_idioma),a.ds_sinal_vital)ds_sinal_vital,
		b.cd_intervalo,
		b.IE_PRIM_HORARIO,
		coalesce(b.ie_faixa, 'F')
	from	sinal_vital_pe_proc b,
		sinal_vital a
	where	a.nr_sequencia	= nr_seq_sinal_vital_w
	and	a.nr_sequencia	= b.nr_seq_sinal
	and	((coalesce(qt_idade_w,0)  between coalesce(b.qt_idade_min,0) and coalesce(b.qt_idade_max,999)) or (coalesce(qt_idade_dia_w,0) between coalesce(b.qt_idade_min_dias,0) and coalesce(b.qt_idade_max_dias,9999)))
	and	coalesce(b.cd_setor_Atendimento,coalesce(cd_setor_Atendimento_w,0))	= coalesce(cd_setor_Atendimento_w,0)
	and	((nr_seq_sinal_vital_w <> 10) or (coalesce(b.cd_escala_dor::text, '') = '' or coalesce(cd_escala_dor_w::text, '') = '' or b.cd_escala_dor = cd_escala_dor_w))
	and	coalesce(b.cd_estabelecimento,cd_estabelecimento_w) = cd_estabelecimento_w
	order by coalesce(b.cd_setor_atendimento,0), coalesce(b.cd_escala_dor,'0') desc, coalesce(b.cd_estabelecimento,0);


BEGIN


cd_estabelecimento_w	:= obter_estabelecimento_ativo;

select	max(nr_atendimento),
	max(dt_sinal_vital),
	max(cd_escala_dor),
	max(coalesce(cd_paciente, obter_Pessoa_Atendimento(nr_atendimento,'C'))),	max(ds_observacao)
into STRICT	nr_atendimento_w,
	dt_sinal_vital_w,
	cd_escala_dor_w,
	cd_pessoa_fisica_w,
	ds_observacao_w
from	atendimento_sinal_vital
where	nr_sequencia = nr_seq_SV_p;


if (coalesce(nr_atendimento_w,0) > 0) then
	cd_setor_Atendimento_w	:= obter_setor_atendimento(nr_atendimento_w);
end if;

select	max(obter_idade(dt_nascimento,clock_timestamp(),'A'))
into STRICT	qt_idade_w
from	pessoa_fisica
where	cd_pessoa_fisica	= cd_pessoa_fisica_w;

qt_idade_dia_w	:= null;
if (coalesce(qt_idade_w,0) = 0) then
	select	obter_idade(dt_nascimento,clock_timestamp(),'DIA')
	into STRICT	qt_idade_dia_w
	from	pessoa_fisica
	where	cd_pessoa_fisica	= cd_pessoa_fisica_w;
end if;


open c01;
loop
fetch c01 into	
	nr_seq_sinal_vital_w,
	nm_atributo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	qt_valor_SV_w := Obter_valor_Dinamico_bv('Select '||nm_atributo_w|| ' from atendimento_sinal_vital where nr_sequencia = :nr_sequencia ', 'nr_sequencia='||nr_seq_SV_p, qt_valor_SV_w, 'S');

				
	if (qt_valor_SV_w IS NOT NULL AND qt_valor_SV_w::text <> '') then			
		open c02;
		loop
		fetch c02 into	
			qt_minima_w,
			qt_maxima_w,
			nr_seq_proc_w,
			qt_tempo_hor_regra_w,
			ds_sinal_vital_w,
			cd_intervalo_w,
			IE_PRIM_HORARIO_w,
			ie_faixa_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
		
			nr_sequencia_pe_prescr_proc_w := null;
			dt_prim_horario_w	:= null;

			if	((ie_faixa_w = 'F' and (qt_valor_SV_w IS NOT NULL AND qt_valor_SV_w::text <> '') and  not(qt_valor_SV_w between qt_minima_w and qt_maxima_w))
			or (ie_faixa_w = 'D' and (qt_valor_SV_w IS NOT NULL AND qt_valor_SV_w::text <> '') and (qt_valor_SV_w between qt_minima_w and qt_maxima_w))) then
		
			dt_nova_intervencao_w	:= clock_timestamp() + (qt_tempo_hor_regra_w/60/24);
			
			if (coalesce(nr_atendimento_w,0) > 0)
				and (coalesce(qt_tempo_hor_regra_w,0) > 0)then
			
				select	max(b.nr_sequencia)
				into STRICT	nr_sequencia_pe_prescr_proc_w
				from	pe_prescricao a,
						pe_prescr_proc b
				where	a.nr_atendimento = nr_atendimento_w
				and		b.nr_seq_prescr = a.nr_sequencia
				and		dt_nova_intervencao_w between a.dt_inicio_prescr and a.dt_validade_prescr
				and		b.nr_seq_proc	= nr_seq_proc_w
				and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
				and		coalesce(a.DT_INATIVACAO::text, '') = ''
				and 	coalesce(a.dt_suspensao::text, '') = ''
				and 	coalesce(b.DT_SUSPENSAO::text, '') = '';
			
			end if;
			
			if (coalesce(nr_sequencia_pe_prescr_proc_w::text, '') = '') then
				if (coalesce(nr_sequencia_pe_prescricao_w,0) = 0) then
					select	nextval('pe_prescricao_seq')
					into STRICT	nr_sequencia_pe_prescricao_w
					;
				
				
					ie_new_record_w	:= true;
					dt_prescricao_w	:= clock_timestamp();
					
					insert into pe_prescricao(	nr_sequencia,
									dt_atualizacao,
									nm_usuario,
									dt_prescricao,
									cd_prescritor,
									nr_atendimento,
									cd_pessoa_fisica,
									dt_liberacao,
									dt_atualizacao_nrec,
									nm_usuario_nrec,
									dt_inicio_prescr,
									dt_validade_prescr,
									nr_prescricao,
									nr_seq_modelo,
									nr_cirurgia,
									nr_seq_saep,
									ie_situacao,
									dt_inativacao,
									nm_usuario_inativacao,
									ds_justificativa,
									cd_perfil_ativo,
									dt_suspensao,
									nm_usuario_susp,
									cd_setor_atendimento,
									nr_seq_assinatura,
									nr_sae_origem,
									ie_rn,
									qt_horas_validade,
									dt_primeiro_horario,
									ie_agora,
									ie_estender_validade,
									nr_seq_triagem)	
					values (	nr_sequencia_pe_prescricao_w,
						clock_timestamp(),
						nm_usuario_p,
						dt_prescricao_w,
						Obter_Pessoa_Fisica_Usuario(nm_usuario_p,'C'),
						nr_atendimento_w,
						cd_pessoa_fisica_w,
						null,
						clock_timestamp(),
						nm_usuario_p,
						null, -- gerado pela trigger
						null, -- gerado pela trigger
						null,
						null,
						null,
						null,
						'A',
						null,
						null,
						null,
						CASE WHEN obter_perfil_ativo=0 THEN null  ELSE obter_perfil_ativo END ,
						null,
						null,
						cd_setor_Atendimento_w,
						null,
						null,
						'N',
						24,
						trunc(clock_timestamp(),'mi'),
						null,
						null,
						null);
				end if;				
								
				if (IE_PRIM_HORARIO_w IS NOT NULL AND IE_PRIM_HORARIO_w::text <> '') then
					dt_prim_horario_w	:= dt_prescricao_w  + (IE_PRIM_HORARIO_w / 24/60);
				end if;

				CALL GQA_Gerar_Interv_Padrao(nr_sequencia_pe_prescricao_w,nr_seq_proc_w,nm_usuario_p,cd_intervalo_w,dt_prim_horario_w);
					
				Select 	count(*)
				into STRICT	qt_itens_associados_w
				from	pe_material_proced
				where	nr_seq_proc = nr_seq_proc_w;	

				if (qt_itens_associados_w > 0) then
				
					CALL gerar_prescricao_sae(nr_sequencia_pe_prescricao_w, nm_usuario_p);
				
				end if;
				
				if (coalesce(ds_sinal_vital_total_w::text, '') = '') then
				
					ds_sinal_vital_total_w := substr(Wheb_mensagem_pck.get_texto(326139)||chr(10)||ds_sinal_vital_w||': '||qt_minima_w||' - '|| qt_maxima_w||chr(10)||
											Wheb_mensagem_pck.get_texto(326140)||': '||substr(obter_desc_intervencoes(nr_seq_proc_w),1,255)||chr(10),1,2000);
				
				else
				
					ds_sinal_vital_total_w := substr(ds_sinal_vital_total_w||chr(10)||ds_sinal_vital_w||': '||qt_minima_w||' - '|| qt_maxima_w||chr(10)||
												Wheb_mensagem_pck.get_texto(326140)||': '||substr(obter_desc_intervencoes(nr_seq_proc_w),1,255)||chr(10),1,2000);
				end if;

							
			else
				select 	max(nr_seq_prescr)
				into STRICT 	nr_seq_prescr_w
				from 	pe_prescr_proc
				where 	nr_sequencia = nr_sequencia_pe_prescr_proc_w;
				
				SELECT * FROM aprazar_item_prescr(	'N', wheb_usuario_pck.get_cd_estabelecimento, nr_atendimento_w, 'E', (qt_tempo_hor_regra_w/60), nr_seq_proc_w, cd_intervalo_w, null, dt_nova_intervencao_w, nr_seq_prescr_w, null, null, 'N', null, null, nm_usuario_p, ie_inconsistencia_w, ds_inconsistentes_w, null, null, null, null, null, 'N', null, null, null, null, '', null, null) INTO STRICT ie_inconsistencia_w, ds_inconsistentes_w;--nr_seq_prot_glic
			end if;
		end if;	

		end loop;
		close c02;
		
	end if;
	
end loop;
close c01;


if (ie_new_record_w) then
	CALL liberar_prescricao_enfemagem(nr_sequencia_pe_prescricao_w,nm_usuario_p);
end if;

	
if (ds_sinal_vital_total_w IS NOT NULL AND ds_sinal_vital_total_w::text <> '') then	
		
	if (ds_observacao_w IS NOT NULL AND ds_observacao_w::text <> '') then
		
		ds_observacao_w := substr(ds_observacao_w || chr(10) ||ds_sinal_vital_total_w,1,2000);

	else
	
		ds_observacao_w := substr(ds_sinal_vital_total_w,1,2000);
	
	end if;	

	update  atendimento_sinal_vital
	set		ds_observacao = ds_observacao_w,
			nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_SV_p;
	
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_reaprazar_sae_regra_sv ( nr_seq_SV_p bigint, nm_usuario_p text) FROM PUBLIC;

