-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE lotes AS (nr_seq_ap_lote_w bigint);


CREATE OR REPLACE PROCEDURE gedipa_atual_prescr_transf_pac ( nr_atendimento_p bigint, nr_prescricao_p bigint, cd_setor_antigo_p bigint, cd_setor_novo_p bigint, nm_usuario_p text) AS $body$
DECLARE

ora2pg_rowcount int;
type vetor is table of lotes index by integer;
type pmh_arraytype is table of prescr_mat_hor.nr_sequencia%type index by integer;

vetor_w				vetor;
ivet_w				integer := 1;
ivet_ww				integer := 1;

pmh_index_w			integer;
array_pmh_w			pmh_arraytype;

ie_setor_antigo_gedipa_w	varchar(1);
ie_setor_novo_gedipa_w		varchar(1);
nr_seq_ap_lote_c01_w		bigint := 0;
nr_seq_processo_w			bigint;
nr_seq_proc_ant_w			adep_processo.nr_sequencia%type;
nr_seq_mat_hor_w			bigint;
nr_seq_ap_lote_c02_w		bigint := 0;
nr_seq_ap_lote_item_w		bigint;
qt_dispensar_w				double precision;
qt_dispensar_hor_w			double precision;
nr_seq_ap_lote_c02_ant_w	bigint := 0;
ie_trans_proc_gedipa_w		varchar(1);
ie_gerar_proc_gedipa_job_w	varchar(1);
cd_local_estoque_setor_novo_w	bigint;
nr_novo_lote_w				bigint;
cd_setores_ged_w			varchar(255);
ie_status_conf_prep_w		varchar(15);
cd_estabelecimento_w		smallint;
ie_cursor_w					varchar(1);
nr_sequencia_w				prescr_material.nr_sequencia%type;
nr_seq_horario_w			prescr_mat_hor.nr_sequencia%type;
nr_seq_horario_ww			prescr_mat_hor.nr_sequencia%type;
ds_prescricoes_w			varchar(4000);
ie_adep_w					varchar(1);
ie_rep_adep_w				varchar(1);
ie_adep_param_w 			varchar(1);
VarIdentPrescrADEP_w 			varchar(5);
ie_separador_c			constant varchar(1) := ',';
ie_ajusta_lote_proc_etiqueta_w varchar(1);
ie_atualizou_processo_w			boolean;
varCancelaLotes_w			varchar(1);
ie_grava_log_rastr_w		varchar(1);

c01 CURSOR FOR
SELECT	nr_seq_lote,
	nr_seq_processo
from	prescr_mat_hor	a
where	a.nr_prescricao = nr_prescricao_p
and (a.ie_agrupador	= 4 or a.dt_horario between clock_timestamp() - interval '43200 seconds' and clock_timestamp() + interval '2 days')
and		((ie_ajusta_lote_proc_etiqueta_w in ('S','N')) or (ie_ajusta_lote_proc_etiqueta_w = 'L' and a.ie_agrupador not in (16,17)))
group by
		nr_seq_lote,
		nr_seq_processo
order by
		nr_seq_lote,
		nr_seq_processo;

c02 CURSOR FOR
SELECT	a.nr_sequencia,
		a.nr_seq_lote,
		b.nr_sequencia,
		a.qt_dispensar,
		a.qt_dispensar_hor
from	ap_lote_item b,
		prescr_mat_hor a
where	b.nr_seq_mat_hor	= a.nr_sequencia
and		b.nr_seq_lote		= a.nr_seq_lote
and	not exists (
		SELECT	1
		from	adep_processo_area x,
			prescr_mat_hor y
		where	x.nr_seq_processo	= y.nr_seq_processo
		and	x.nr_seq_processo	= nr_seq_processo_w
		and	y.nr_seq_processo 	= nr_seq_processo_w
		and	y.nr_seq_lote	  	= a.nr_seq_lote
		and	Obter_se_horario_liberado(y.dt_lib_horario, y.dt_horario) = 'S')
and	exists (
		select	1
		from	adep_processo_area x,
			prescr_mat_hor y,
			ap_lote z
		where	x.nr_seq_processo	= y.nr_seq_processo
		and	y.nr_seq_lote	  	= z.nr_sequencia
		and	z.nr_sequencia	  	= a.nr_seq_lote
		and	coalesce(z.dt_impressao::text, '') = ''
		and	Obter_se_horario_liberado(y.dt_lib_horario, y.dt_horario) = 'S')
and		Obter_se_horario_liberado(a.dt_lib_horario, a.dt_horario) = 'S'
and		a.nr_seq_processo	= nr_seq_processo_w
group by
	a.nr_sequencia,
	a.nr_seq_lote,
	b.nr_sequencia,
	a.qt_dispensar,
	a.qt_dispensar_hor
order by
	a.nr_seq_lote,
	b.nr_sequencia;

c03 CURSOR FOR
SELECT	'M' ie_cursor,
	a.nr_sequencia nr_seq_material,
	b.nr_sequencia nr_seq_horario,
	a.nr_prescricao nr_prescricao
from	prescr_material a,
	prescr_mat_hor b
where	a.nr_prescricao = b.nr_prescricao
and	a.nr_sequencia	= b.nr_seq_material
and	(b.dt_lib_horario IS NOT NULL AND b.dt_lib_horario::text <> '')
and	a.ie_agrupador not in (4,13)
and	((ie_ajusta_lote_proc_etiqueta_w in ('S','N')) or (ie_ajusta_lote_proc_etiqueta_w = 'L' and a.ie_agrupador not in (16,17)))
and	b.nr_sequencia	= nr_seq_horario_ww

union all

SELECT	'S' ie_cursor,
	a.nr_sequencia_solucao nr_seq_material,
	b.nr_sequencia nr_seq_horario,
	a.nr_prescricao nr_prescricao
from	prescr_material a,
	prescr_mat_hor b
where	a.nr_prescricao = b.nr_prescricao
and	a.nr_sequencia	= b.nr_seq_material
and	(b.dt_lib_horario IS NOT NULL AND b.dt_lib_horario::text <> '')
and	a.ie_agrupador in (4,13)
and	((ie_ajusta_lote_proc_etiqueta_w in ('S','N')) or (ie_ajusta_lote_proc_etiqueta_w = 'L' and a.ie_agrupador not in (16,17)))
and	(a.nr_sequencia_solucao IS NOT NULL AND a.nr_sequencia_solucao::text <> '')
and	b.nr_sequencia	= nr_seq_horario_ww;

c04 CURSOR(nr_prescricao_pc 	prescr_medica.nr_prescricao%type) FOR
SELECT	a.nr_sequencia
from 	prescr_mat_hor a
where	a.nr_prescricao	= nr_prescricao_pc
and (a.ie_agrupador	= 4 or a.dt_horario between clock_timestamp() - interval '43200 seconds' and clock_timestamp() + interval '2 days')
and ((a.nr_seq_processo IS NOT NULL AND a.nr_seq_processo::text <> '')
or		ie_setor_novo_gedipa_w = 'S');

c_prescricoes CURSOR(ds_lista_prescricoes_pc 	text) FOR
	SELECT	distinct (x.cd_registro)::numeric  nr_prescricao
	from 	table(lista_pck.obter_lista_char(ds_lista_prescricoes_pc,ie_separador_c)) x;

BEGIN

ie_grava_log_rastr_w := obter_rastreabilidade_adep(nr_prescricao_p, 'GP');

if (ie_grava_log_rastr_w = 'S') then
    CALL adep_gerar_log_rastr('{'||chr(10)||
        '"'||$$plsql_unit||'" : "'||$$plsql_line||'",'||chr(10)||
        '"cd_setor_antigo_p" : "'||cd_setor_antigo_p||'",'||chr(10)||
        '"cd_setor_novo_p" : "'||cd_setor_novo_p||'",'||chr(10)||
        '"nm_usuario_p" : "'||nm_usuario_p||'",'||chr(10)||
        '"nr_atendimento_p" : "'||nr_atendimento_p||'",'||chr(10)||
        '"nr_prescricao_p" : "'||nr_prescricao_p||'"}');
end if;

if (obter_funcao_ativa = 252) then
	VarIdentPrescrADEP_w := obter_param_usuario(252, 27, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, VarIdentPrescrADEP_w);
else
	VarIdentPrescrADEP_w := obter_param_usuario(7015, 62, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, VarIdentPrescrADEP_w);
end if;

select	coalesce(max(cd_estabelecimento),1),
		max(coalesce(ie_adep,obter_se_setor_adep(cd_setor_atendimento))),
		max(ie_adep)
into STRICT	cd_estabelecimento_w,
		ie_rep_adep_w,
		ie_adep_param_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;


if (cd_setor_novo_p > 0) then
	select	coalesce(max(ie_adep),'N')
	into STRICT	ie_rep_adep_w
	from	setor_atendimento
	where	cd_setor_atendimento = cd_setor_novo_p;
end if;

	if (VarIdentPrescrADEP_w = 'DS') then
		ie_adep_w := ie_rep_adep_w;
	elsif (VarIdentPrescrADEP_w = 'NV') then
		ie_adep_w := 'N';
	elsif (VarIdentPrescrADEP_w = 'SV') then
		ie_adep_w := 'S';
	elsif (VarIdentPrescrADEP_w = 'PV') or (VarIdentPrescrADEP_w = 'PNV') then
		ie_adep_w := ie_adep_param_w;
	end if;


cd_setores_ged_w := Obter_Param_Usuario(3111, 251, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, cd_setores_ged_w);
ie_status_conf_prep_w := Obter_Param_Usuario(3112, 82, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_status_conf_prep_w);
ie_ajusta_lote_proc_etiqueta_w := obter_param_usuario(3111, 73, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_ajusta_lote_proc_etiqueta_w);
varCancelaLotes_w := obter_param_usuario(7029, 121, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, varCancelaLotes_w);

ie_ajusta_lote_proc_etiqueta_w := coalesce(trim(both ie_ajusta_lote_proc_etiqueta_w),'N');

if (obter_rastreabilidade_adep(nr_prescricao_p, 'GP') = 'S') then
    CALL adep_gerar_log_rastr('{'||chr(10)||
        '"'||$$plsql_unit||'" : "'||$$plsql_line||'",'||chr(10)||
        '"VarIdentPrescrADEP_w" : "'||VarIdentPrescrADEP_w||'",'||chr(10)||
        '"cd_estabelecimento_w" : "'||cd_estabelecimento_w||'",'||chr(10)||
        '"cd_setor_novo_p" : "'||cd_setor_novo_p||'",'||chr(10)||
        '"cd_setores_ged_w" : "'||cd_setores_ged_w||'",'||chr(10)||
        '"ie_adep_param_w" : "'||ie_adep_param_w||'",'||chr(10)||
        '"ie_adep_w" : "'||ie_adep_w||'",'||chr(10)||
        '"ie_ajusta_lote_proc_etiqueta_w" : "'||ie_ajusta_lote_proc_etiqueta_w||'",'||chr(10)||
        '"ie_rep_adep_w" : "'||ie_rep_adep_w||'",'||chr(10)||
        '"ie_status_conf_prep_w" : "'||ie_status_conf_prep_w||'",'||chr(10)||
        '"nm_usuario_p" : "'||nm_usuario_p||'",'||chr(10)||
        '"nr_prescricao_p" : "'||nr_prescricao_p||'",'||chr(10)||
        '"varCancelaLotes_w" : "'||varCancelaLotes_w||'"}');
end if;

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (cd_setor_antigo_p IS NOT NULL AND cd_setor_antigo_p::text <> '') and (cd_setor_novo_p IS NOT NULL AND cd_setor_novo_p::text <> '') then
	begin

	select	coalesce(max(ie_trans_proc_gedipa),'N'),
			coalesce(max(ie_gerar_proc_gedipa_job),'N')
	into STRICT	ie_trans_proc_gedipa_w,
			ie_gerar_proc_gedipa_job_w
	from	parametros_farmacia
	where	cd_estabelecimento = cd_estabelecimento_w;

	ie_setor_antigo_gedipa_w	:= obter_se_setor_processo_gedipa(cd_setor_antigo_p);
	ie_setor_novo_gedipa_w		:= obter_se_setor_processo_gedipa(cd_setor_novo_p);

	if (ie_grava_log_rastr_w = 'S') then
		CALL adep_gerar_log_rastr('{'||chr(10)||
            '"'||$$plsql_unit||'" : "'||$$plsql_line||'",'||chr(10)||
            '"cd_estabelecimento_w" : "'||cd_estabelecimento_w||'",'||chr(10)||
            '"cd_setor_antigo_p" : "'||cd_setor_antigo_p||'",'||chr(10)||
            '"cd_setor_novo_p" : "'||cd_setor_novo_p||'",'||chr(10)||
            '"ie_gerar_proc_gedipa_job_w" : "'||ie_gerar_proc_gedipa_job_w||'",'||chr(10)||
            '"ie_setor_antigo_gedipa_w" : "'||ie_setor_antigo_gedipa_w||'",'||chr(10)||
            '"ie_setor_novo_gedipa_w" : "'||ie_setor_novo_gedipa_w||'",'||chr(10)||
            '"ie_trans_proc_gedipa_w" : "'||ie_trans_proc_gedipa_w||'"}');
	end if;

	if (ie_setor_antigo_gedipa_w = 'S') and (ie_setor_novo_gedipa_w = 'N') and (ie_trans_proc_gedipa_w = 'N') then
		begin
		CALL define_local_disp_prescr(nr_prescricao_p, null, obter_perfil_ativo, nm_usuario_p);

		if (ie_grava_log_rastr_w = 'S') then
			CALL adep_gerar_log_rastr('{'||chr(10)||
                '"'||$$plsql_unit||'" : "'||$$plsql_line||'",'||chr(10)||
				'"ie_ajusta_lote_proc_etiqueta_w" : "'||ie_ajusta_lote_proc_etiqueta_w||'",'||chr(10)||
				'"nr_prescricao_p" : "'||nr_prescricao_p||'"}');
		end if;

		open c01;
		loop
		fetch c01 into 	nr_seq_ap_lote_c01_w,
				nr_seq_processo_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin
			update	adep_processo a
			set		a.dt_cancelamento		= clock_timestamp(),
					a.nm_usuario_cancelamento	= nm_usuario_p,
					a.nm_usuario			= 'WGAPTP0209'
			where	not exists ( SELECT 1 from adep_processo_area x where x.nr_seq_processo = a.nr_sequencia)
			and		coalesce(a.dt_preparo::text, '') = ''
			and		a.nr_sequencia			= nr_seq_processo_w;

			if (ie_grava_log_rastr_w = 'S') then
				CALL adep_gerar_log_rastr('{'||chr(10)||
                    '"'||$$plsql_unit||'" : "'||$$plsql_line||'",'||chr(10)||
					'"nr_seq_processo_w" : "'||nr_seq_processo_w||'"}');
			end if;

			open c02;
			loop
			fetch c02 into	nr_seq_mat_hor_w,
					nr_seq_ap_lote_c02_w,
					nr_seq_ap_lote_item_w,
					qt_dispensar_w,
					qt_dispensar_hor_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
				begin
				if (nr_seq_ap_lote_c01_w = nr_seq_ap_lote_c02_w) then
					begin
					CALL gerar_w_ap_lote_desdob(nr_seq_ap_lote_c02_w, nr_seq_ap_lote_item_w, nr_seq_mat_hor_w, 2 * qt_dispensar_hor_w, qt_dispensar_hor_w);
					end;
				else
					begin
					nr_novo_lote_w := desdobrar_lote_prescricao(nr_seq_ap_lote_c02_ant_w, nm_usuario_p, 'D', 0, '', '', nr_novo_lote_w);
					vetor_w[ivet_w].nr_seq_ap_lote_w	:= nr_seq_ap_lote_c02_ant_w;

					delete
					from	w_ap_lote_desdob
					where	nr_seq_lote = nr_seq_ap_lote_c02_w;

					CALL gerar_w_ap_lote_desdob(nr_seq_ap_lote_c02_w, nr_seq_ap_lote_item_w, nr_seq_mat_hor_w, 2 * qt_dispensar_hor_w, qt_dispensar_hor_w);
					end;
				end if;
				nr_seq_ap_lote_c02_ant_w	:= nr_seq_ap_lote_c02_w;
				end;
			end loop;
			close c02;

			update	prescr_mat_hor a
			set		a.nr_seq_processo	 = NULL,
					a.nr_seq_etiqueta	 = NULL,
					a.dt_emissao_farmacia	 = NULL,
					a.nm_usuario		= 'WGAPTP0209'
			where	not exists ( SELECT 1 from adep_processo_area x where x.nr_seq_processo = a.nr_seq_processo)
			and		exists ( select 1 from adep_processo x where coalesce(x.dt_preparo::text, '') = '' and x.nr_seq_processo = a.nr_seq_processo)
			and		a.nr_seq_processo	= nr_seq_processo_w;
			end;
		end loop;
		close c01;

		if (nr_seq_ap_lote_c02_ant_w > 0) then
			begin
			nr_novo_lote_w := desdobrar_lote_prescricao(nr_seq_ap_lote_c02_ant_w, nm_usuario_p, 'D', 0, '', '', nr_novo_lote_w);
			vetor_w[ivet_w].nr_seq_ap_lote_w	:= nr_seq_ap_lote_c02_ant_w;
			end;
		end if;

		while(ivet_ww < ivet_w) loop
			begin
			update	ap_lote
			set		dt_impressao	= clock_timestamp(),
					nm_usuario	= 'WGAPTP0209'
			where	coalesce(dt_impressao::text, '') = ''
			and		nr_sequencia	= vetor_w[ivet_ww].nr_seq_ap_lote_w;

			ivet_ww	:= ivet_ww + 1;
			end;
		end loop;

		update	ap_lote a
		set		a.cd_local_estoque = (
					SELECT	max(x.cd_local_estoque)
					from	prescr_material x,
							prescr_mat_hor y
					where	x.nr_prescricao	= y.nr_prescricao
					and		x.nr_sequencia	= y.nr_seq_material
					and		x.nr_prescricao	= nr_prescricao_p
					and		y.nr_prescricao	= nr_prescricao_p
					and		Obter_se_horario_liberado(y.dt_lib_horario, y.dt_horario) = 'S'
					and		y.nr_seq_lote	= a.nr_sequencia
					),
				a.cd_setor_atendimento = coalesce(cd_setor_novo_p, a.cd_setor_atendimento),
				a.nm_usuario	= 'WGAPTP0209'
		where	coalesce(a.dt_impressao::text, '') = ''
		and		a.nr_prescricao	= nr_prescricao_p
		and		a.dt_atend_lote > clock_timestamp() /* OS 150445 Historico de 07/08/2009 17:33:48 */
		and 	coalesce(a.ie_agrupamento,'N') = 'N';

		update	ap_lote a
		set		a.dt_impressao	= clock_timestamp(),
				a.nm_usuario	= 'WGAPTP0209'
		where	coalesce(a.dt_impressao::text, '') = ''
		and		a.nr_sequencia	in (
					SELECT	y.nr_seq_lote
					from	adep_processo_area x,
							prescr_mat_hor y
					where	x.nr_seq_processo	= y.nr_seq_processo
					and		y.nr_prescricao		= nr_prescricao_p
					and		Obter_se_horario_liberado(y.dt_lib_horario, y.dt_horario) = 'S'
					and		y.nr_seq_lote	  	= a.nr_sequencia
					)
		and		a.nr_prescricao	= nr_prescricao_p;
		end;
	elsif (ie_setor_antigo_gedipa_w = 'N') and (ie_setor_novo_gedipa_w = 'S') and (ie_trans_proc_gedipa_w = 'N') then
		begin
		CALL define_local_disp_prescr(nr_prescricao_p, null, obter_perfil_ativo, nm_usuario_p);

		cd_local_estoque_setor_novo_w	:= obter_local_estoque_setor(cd_setor_novo_p, obter_estab_atend(nr_atendimento_p));

		update	prescr_medica
		set		ie_adep		= ie_adep_w,
				nm_usuario	= 'WGAPTP0209'
		where	nr_prescricao	= nr_prescricao_p;

		update	ap_lote
		set		cd_local_estoque	= cd_local_estoque_setor_novo_w,
				cd_setor_atendimento = coalesce(cd_setor_novo_p, cd_setor_atendimento),
				nm_usuario		= 'WGAPTP0209'
		where	coalesce(dt_atend_farmacia::text, '') = ''
		and		nr_prescricao		= nr_prescricao_p
		and 	coalesce(ie_agrupamento,'N') = 'N';
		
		if (coalesce(varCancelaLotes_w,'N') = 'S') then
			update	ap_lote
			set		ie_status_lote = 'C',
					dt_cancelamento = clock_timestamp(),
					nm_usuario_cancelamento	= nm_usuario_p
			where	coalesce(dt_atend_farmacia::text, '') = ''
			and 	ie_status_lote = 'G'
			and		nr_prescricao = nr_prescricao_p;
		end if;
	
		update	prescr_mat_hor a
		set		a.ie_adep	= ie_adep_w,
				a.nm_usuario	= 'WGAPTP0209'
		where	not exists (
					SELECT	1
					from	ap_lote x
					where	(x.dt_atend_farmacia IS NOT NULL AND x.dt_atend_farmacia::text <> '')
					and		x.nr_sequencia		= a.nr_seq_lote)
		and		a.nr_prescricao	= nr_prescricao_p;


		if (ie_trans_proc_gedipa_w = 'N') then
			update	prescr_mat_hor a
			set		--a.ie_adep	= 'N',
					a.ie_gedipa	= 'N',
					a.nm_usuario	= 'WGAPTP0209'
			where	exists (
						SELECT	1
						from	ap_lote x
						where	(x.dt_atend_farmacia IS NOT NULL AND x.dt_atend_farmacia::text <> '')
						and		x.nr_sequencia		= a.nr_seq_lote)
			and		a.nr_prescricao	= nr_prescricao_p;
		else
			update	prescr_mat_hor a
			set		--a.ie_adep	= 'N',
					a.ie_gedipa	= 'N',
					a.nm_usuario	= 'WGAPTP0209'
			where	gedipa_obter_gerar_proc_status(clock_timestamp() - interval '3 days', 'AP_LOTE', a.nr_seq_lote,a.ie_gedipa,a.nr_seq_processo, a.nr_seq_area_prep, null)	= 'N'
			and		a.nr_prescricao	= nr_prescricao_p;
		end if;

		CALL adep_gerar_area_prep(nr_prescricao_p, null, nm_usuario_p);
		end;
	elsif (ie_trans_proc_gedipa_w = 'S') then

		if (obter_classif_setor(cd_setor_novo_p) <> 4) or (obter_se_contido(cd_setor_novo_p,cd_setores_ged_w) = 'S' ) then

			CALL define_local_disp_prescr(nr_prescricao_p, null, obter_perfil_ativo, nm_usuario_p);

			if (ie_status_conf_prep_w = 'S') then
				update	adep_processo a
				set		a.ie_status_processo	= 'P',
						a.dt_leitura 		 = NULL,
						a.nm_usuario_leitura	 = NULL
				where	a.ie_status_processo	= 'L'
				and		a.nr_sequencia in (	SELECT	b.nr_seq_processo from prescr_mat_hor b where b.nr_prescricao = nr_prescricao_p );
				if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
			end if;

			update	ap_lote a
			set	a.cd_local_estoque = (
						SELECT	coalesce(max(y.cd_local_estoque), max(x.cd_local_estoque))
						from	prescr_material x,
							prescr_mat_hor y
						where	x.nr_prescricao	= y.nr_prescricao
						and	x.nr_sequencia	= y.nr_seq_material
						and	x.nr_prescricao	= nr_prescricao_p
						and	y.nr_prescricao	= nr_prescricao_p
						and	y.nr_seq_lote	= a.nr_sequencia
						and	Obter_se_horario_liberado(y.dt_lib_horario, y.dt_horario) = 'S'),
				a.cd_setor_atendimento = coalesce(cd_setor_novo_p, a.cd_setor_atendimento),
				a.nm_usuario	= 'WGAPTP0209'
			where	a.nr_sequencia	not in (
						SELECT	y.nr_seq_lote
						from	adep_processo_area x,
							prescr_mat_hor y
						where	x.nr_seq_processo	= y.nr_seq_processo
						and	y.nr_prescricao		= nr_prescricao_p
						and	y.nr_seq_lote	  	= a.nr_sequencia
						and	Obter_se_horario_liberado(y.dt_lib_horario, y.dt_horario) = 'S')
			and		coalesce(a.dt_impressao::text, '') = ''
			and		a.nr_prescricao	= nr_prescricao_p
			and 	coalesce(a.ie_agrupamento,'N') = 'N';


			--and	a.dt_atend_lote > sysdate; /* OS 150445 Historico de 07/08/2009 17:33:48 */
			if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;

			update	ap_lote a
			set		a.dt_impressao	= clock_timestamp(),
					a.nm_usuario	= 'WGAPTP0209'
			where	a.nr_sequencia	in (
						SELECT	y.nr_seq_lote
						from	adep_processo_area x,
							prescr_mat_hor y
						where	x.nr_seq_processo	= y.nr_seq_processo
						and	y.nr_prescricao		= nr_prescricao_p
						and	y.nr_seq_lote	  	= a.nr_sequencia
						and	Obter_se_horario_liberado(y.dt_lib_horario, y.dt_horario) = 'S')
			and		coalesce(a.dt_impressao::text, '') = ''
			and		a.nr_prescricao	= nr_prescricao_p;
		else
			CALL define_local_disp_prescr(nr_prescricao_p, null, obter_perfil_ativo, nm_usuario_p);

			cd_local_estoque_setor_novo_w	:= obter_local_estoque_setor(cd_setor_novo_p, obter_estab_atend(nr_atendimento_p));

			update	prescr_medica
			set		ie_adep		= ie_adep_w,
					nm_usuario	= 'WGAPTP0209'
			where	nr_prescricao	= nr_prescricao_p;

			update	ap_lote
			set		cd_local_estoque	= cd_local_estoque_setor_novo_w,
					cd_setor_atendimento = coalesce(cd_setor_novo_p, cd_setor_atendimento),
					nm_usuario		= 'WGAPTP0209'
			where	coalesce(dt_atend_farmacia::text, '') = ''
			and		nr_prescricao		= nr_prescricao_p
			and 	coalesce(ie_agrupamento,'N') = 'N';

			update	prescr_mat_hor a
			set		a.ie_adep	= ie_adep_w,
					a.nm_usuario	= 'WGAPTP0209'
			where	not exists (
						SELECT	1
						from	ap_lote x
						where	x.nr_sequencia		= a.nr_seq_lote
						and	(x.dt_atend_farmacia IS NOT NULL AND x.dt_atend_farmacia::text <> ''))
			and		a.nr_prescricao	= nr_prescricao_p;

			if (ie_trans_proc_gedipa_w = 'N') then
				update	prescr_mat_hor a
				set		--a.ie_adep	= 'N',
						a.ie_gedipa	= 'N',
						a.nm_usuario	= 'WGAPTP0209'
				where	exists (
							SELECT	1
							from	ap_lote x
							where	x.nr_sequencia		= a.nr_seq_lote
							and	(x.dt_atend_farmacia IS NOT NULL AND x.dt_atend_farmacia::text <> ''))
				and		a.nr_prescricao	= nr_prescricao_p;
			else
				update	prescr_mat_hor a
				set		--a.ie_adep	= 'N',
						a.ie_gedipa	= 'N',
						a.nm_usuario	= 'WGAPTP0209'
				where	gedipa_obter_gerar_proc_transf(clock_timestamp() - interval '3 days', 'AP_LOTE', a.nr_seq_lote,a.ie_gedipa,a.nr_seq_processo, a.nr_seq_area_prep, null)	= 'N'
				and		a.nr_prescricao	= nr_prescricao_p;
			end if;
		end if;

		nr_seq_proc_ant_w	:= 0;
		ds_prescricoes_w	:= '';

		if (ie_grava_log_rastr_w = 'S') then
			CALL adep_gerar_log_rastr('{'||chr(10)||
                '"'||$$plsql_unit||'" : "'||$$plsql_line||'",'||chr(10)||
				'"ie_ajusta_lote_proc_etiqueta_w" : "'||ie_ajusta_lote_proc_etiqueta_w||'",'||chr(10)||
				'"nr_prescricao_p" : "'||nr_prescricao_p||'"}');
		end if;

		open c01;
		loop
		fetch c01 into 	nr_seq_ap_lote_c01_w,
				nr_seq_processo_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			begin

			update	adep_processo a
			set	a.dt_cancelamento		= clock_timestamp(),
				a.nm_usuario_cancelamento	= nm_usuario_p,
				a.nm_usuario			= 'WGAPTP0209'
			where	not exists ( SELECT 1 from adep_processo_area x where x.nr_seq_processo = a.nr_sequencia)
			and	coalesce(a.dt_preparo::text, '') = ''
			and	coalesce(a.dt_cancelamento::text, '') = ''
			and	a.nr_sequencia			= nr_seq_processo_w;

			GET DIAGNOSTICS ora2pg_rowcount = ROW_COUNT;


			ie_atualizou_processo_w	:= ( ora2pg_rowcount > 0);

			if	((nr_seq_proc_ant_w <> nr_seq_processo_w) and ie_atualizou_processo_w) then			
				if (ds_prescricoes_w IS NOT NULL AND ds_prescricoes_w::text <> '') then
					ds_prescricoes_w	:= ds_prescricoes_w || ie_separador_c;
				end if;

				ds_prescricoes_w	:= ds_prescricoes_w || adep_obter_prescr_processo(nr_seq_processo_w,ie_separador_c);
			end if;

			nr_seq_proc_ant_w	:= nr_seq_processo_w;
			end;
		end loop;
		close c01;

        if (obter_rastreabilidade_adep(nr_prescricao_p, 'GP') = 'S') then
            CALL adep_gerar_log_rastr('{'||chr(10)||
                '"'||$$plsql_unit||'" : "'||$$plsql_line||'",'||chr(10)||
                '"ds_prescricoes_w" : "'||ds_prescricoes_w||'"}');
        end if;
				
		if (ds_prescricoes_w IS NOT NULL AND ds_prescricoes_w::text <> '') then			
			array_pmh_w.delete;
			pmh_index_w	:= 0;

			for c_prescricoes_w in c_prescricoes(ds_prescricoes_w) loop
				begin

				if (ie_grava_log_rastr_w = 'S') then
					CALL adep_gerar_log_rastr('{'||chr(10)||
                        '"'||$$plsql_unit||'" : "'||$$plsql_line||'",'||chr(10)||
						'"c_prescricoes_w.nr_prescricao" : "'||c_prescricoes_w.nr_prescricao||'",'||chr(10)||
						'"ie_setor_novo_gedipa_w" : "'||ie_setor_novo_gedipa_w||'"}');
				end if;
				
				for c04_w in c04(c_prescricoes_w.nr_prescricao) loop
					begin
					pmh_index_w	:= pmh_index_w + 1;
					array_pmh_w(pmh_index_w) := c04_w.nr_sequencia;
					end;
				end loop;

				update	prescr_mat_hor a
				set	a.nr_seq_processo		 = NULL,
					a.nr_seq_etiqueta		 = NULL,
					a.dt_emissao_farmacia		 = NULL,
					a.nm_usuario			= 'WGAPTP0209',
					a.nr_seq_area_prep		 = NULL,
					a.nr_seq_regra_area_prep	 = NULL
				where	exists (	SELECT	1
							from 	adep_processo x
							where 	x.nr_sequencia = a.nr_seq_processo
							and 	(x.dt_cancelamento IS NOT NULL AND x.dt_cancelamento::text <> '')
							and 	x.nm_usuario = 'WGAPTP0209')
				and	a.nr_prescricao	= c_prescricoes_w.nr_prescricao;

				CALL adep_gerar_area_prep(c_prescricoes_w.nr_prescricao, null, nm_usuario_p);
				end;
			end loop;
		end if;

		if (ie_gerar_proc_gedipa_job_w = 'N') then
			for i in 1 .. array_pmh_w.count
			loop
				nr_seq_horario_ww	:= array_pmh_w(i);
				
				if (ie_grava_log_rastr_w = 'S') then
					CALL adep_gerar_log_rastr('{'||chr(10)||
                        '"'||$$plsql_unit||'" : "'||$$plsql_line||'",'||chr(10)||
						'"ie_ajusta_lote_proc_etiqueta_w" : "'||ie_ajusta_lote_proc_etiqueta_w||'",'||chr(10)||
						'"nr_seq_horario_ww" : "'||nr_seq_horario_ww||'"}');
				end if;
				
				for c03_w in c03 loop
					begin
					if (c03_w.ie_cursor = 'M') then
						CALL Gedipa_Gerar_Proc_Instantaneo(c03_w.nr_prescricao,c03_w.nr_seq_material,null,c03_w.nr_seq_horario);
					else
						CALL Gedipa_Gerar_Proc_Instantaneo(c03_w.nr_prescricao,null,c03_w.nr_seq_material,c03_w.nr_seq_horario);
					end if;
					end;
				end loop;
			end loop;
		end if;
	end if;
	end;
end if;
if (coalesce(wheb_usuario_pck.get_ie_commit, 'S') = 'S') then commit; end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gedipa_atual_prescr_transf_pac ( nr_atendimento_p bigint, nr_prescricao_p bigint, cd_setor_antigo_p bigint, cd_setor_novo_p bigint, nm_usuario_p text) FROM PUBLIC;
