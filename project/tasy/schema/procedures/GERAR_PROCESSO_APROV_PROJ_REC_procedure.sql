-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_processo_aprov_proj_rec (nr_seq_proj_rec_p projeto_recurso.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text ) AS $body$
DECLARE


nr_seq_aprovacao_w	projeto_recurso.nr_seq_aprovacao%type;
nr_seq_proc_aprov_w	projeto_recurso.nr_seq_proc_aprov%type;
cd_processo_aprov_w	processo_aprov_resp.cd_processo_aprov%type;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
dt_aprovacao_w		projeto_recurso.dt_aprovacao%type;
cd_centro_custo_w	projeto_recurso.cd_centro_custo%type;

cd_perfil_ativo_w	perfil.cd_perfil%type := obter_perfil_ativo;
dt_liberacao_w		processo_aprov_compra.dt_liberacao%type;
cd_responsavel_w	processo_aprov_compra.cd_pessoa_fisica%type;
nr_nivel_aprovacao_w2	processo_aprov_compra.nr_nivel_aprovacao%type;
ie_aprovacao_nivel_w	varchar(1);
dt_emissao_w		processo_aprov_compra.dt_documento%type := clock_timestamp();

type t_date_table is table of timestamp index by integer;

tb_nr_seq_proc_compra_w	dbms_sql.number_table;
tb_cd_processo_aprov_w	dbms_sql.number_table;

tb_nr_seq_aprov_w	dbms_sql.number_table;
tb_nr_seq_aprov_comp_w	dbms_sql.number_table;
tb_nr_seq_proc_aprov_w	dbms_sql.number_table;
tb_cd_pessoa_fisica_w	dbms_sql.varchar2_table;
tb_cargo_w		dbms_sql.number_table;
tb_dt_liberacao_w	t_date_table;
tb_dt_definicao_w	t_date_table;
tb_ie_aprov_reprov_w	dbms_sql.varchar2_table;
tb_ie_urgente_w		dbms_sql.varchar2_table;
tb_nr_documento_w	dbms_sql.number_table;
tb_ie_tipo_w		dbms_sql.varchar2_table;
tb_dt_documento_w	t_date_table;
tb_nr_nivel_aprovacao_w dbms_sql.number_table;
tb_ie_responsavel_w	dbms_sql.varchar2_table;
tb_nm_usuario_regra_w	dbms_sql.varchar2_table;
tb_vl_minimo_w		dbms_sql.number_table;
tb_vl_maximo_w		dbms_sql.number_table;
tb_qt_minimo_aprovador_w dbms_sql.number_table;
tb_qt_itens_regra_w	dbms_sql.number_table;
tb_qt_intervalo_regra_w	dbms_sql.number_table;

nr_proc_compra_w	integer;
nr_proc_aprov_w		integer;

c01 CURSOR( cd_processo_aprov_pc  processo_aprov_resp.cd_processo_aprov%type) FOR
	SELECT	nr_sequencia,
		ie_responsavel,
		cd_cargo,
		nm_usuario_regra,
		nr_nivel_aprovacao,
		ie_contr_proj_rec_externo,
		vl_minimo,
		vl_maximo,
		qt_minimo_aprovador,
		qt_itens_regra,
		qt_intervalo_regra
	from	processo_aprov_resp
	where	cd_processo_aprov = cd_processo_aprov_pc;

c02 CURSOR( nr_seq_proj_rec_pc	 projeto_recurso.nr_sequencia%type) FOR
	SELECT	nr_seq_aprovacao
	from	projeto_recurso
	where	nr_sequencia = nr_seq_proj_rec_pc
	and	(nr_seq_aprovacao IS NOT NULL AND nr_seq_aprovacao::text <> '');
BEGIN

select	max(nr_seq_aprovacao),
	max(nr_seq_proc_aprov),
	max(cd_estabelecimento),
	max(dt_aprovacao),
	max(cd_centro_custo)
into STRICT	nr_seq_aprovacao_w,
	nr_seq_proc_aprov_w,
	cd_estabelecimento_w,
	dt_aprovacao_w,
	cd_centro_custo_w
from	projeto_recurso
where	nr_sequencia = nr_seq_proj_rec_p;

if (coalesce(nr_seq_aprovacao_w::text, '') = '') then

	cd_processo_aprov_w := obter_processo_aprovacao(null, cd_centro_custo_w, null, null, null, null, null, null, null, 'E', null, cd_estabelecimento_w, cd_perfil_ativo_w, nr_seq_proj_rec_p, nr_seq_proj_rec_p, cd_processo_aprov_w);

	if (cd_processo_aprov_w IS NOT NULL AND cd_processo_aprov_w::text <> '') then

		nr_proc_compra_w := 1;
		nr_proc_aprov_w := 1;
		for r_C01_w in C01( cd_processo_aprov_w ) loop

			if (coalesce(r_C01_w.ie_contr_proj_rec_externo, 'N') = 'S') then

				select	coalesce(max(b.nr_sequencia),0)
				into STRICT	nr_seq_aprovacao_w
				from	processo_aprov_compra a,
					processo_compra b
				where	b.nr_sequencia = a.nr_sequencia
				and	b.cd_processo_aprov = cd_processo_aprov_w
				and	a.nr_documento = nr_seq_proj_rec_p
				and	a.cd_estabelecimento = cd_estabelecimento_w
				and	a.ie_tipo = 'E';

				if (nr_seq_aprovacao_w = 0) then
				
					select	nextval('processo_compra_seq')
					into STRICT	nr_seq_aprovacao_w
					;
				
					tb_nr_seq_proc_compra_w(nr_proc_compra_w) := nr_seq_aprovacao_w;
					tb_cd_processo_aprov_w(nr_proc_compra_w) := cd_processo_aprov_w;
					nr_proc_compra_w := nr_proc_compra_w + 1;

					dt_liberacao_w := clock_timestamp();
					cd_responsavel_w := null;

					if (r_C01_w.ie_responsavel <> 'F') then

						if (r_C01_w.nr_nivel_aprovacao IS NOT NULL AND r_C01_w.nr_nivel_aprovacao::text <> '') and (coalesce(dt_liberacao_w::text, '') = '') then

							ie_aprovacao_nivel_w := obter_se_proc_por_nivel(nr_seq_aprovacao_w, cd_estabelecimento_w);
							dt_liberacao_w  := null;
							
							if (ie_aprovacao_nivel_w = 'S') and (nr_nivel_aprovacao_w2 = r_C01_w.nr_nivel_aprovacao) then
								dt_liberacao_w  := clock_timestamp();
							end if;

						end if;
						
						tb_nr_seq_aprov_comp_w(nr_proc_aprov_w) := nr_seq_aprovacao_w;
						tb_nr_seq_proc_aprov_w(nr_proc_aprov_w) := r_C01_w.nr_sequencia;
						tb_cd_pessoa_fisica_w(nr_proc_aprov_w) := cd_responsavel_w;
						tb_cargo_w(nr_proc_aprov_w) := r_C01_w.cd_cargo;
						tb_dt_liberacao_w(nr_proc_aprov_w) := dt_liberacao_w;
						tb_dt_definicao_w(nr_proc_aprov_w) := null;
						
						if (coalesce(r_c01_w.cd_cargo::text, '') = '') then
							tb_dt_definicao_w(nr_proc_aprov_w) := clock_timestamp();
						end if;
						
						tb_ie_aprov_reprov_w(nr_proc_aprov_w) := 'P';
						tb_ie_urgente_w(nr_proc_aprov_w) := 'N';
						tb_nr_documento_w(nr_proc_aprov_w) := nr_seq_proj_rec_p;
						tb_ie_tipo_w(nr_proc_aprov_w) := 'E';
						tb_dt_documento_w(nr_proc_aprov_w) := dt_emissao_w;
						tb_nr_seq_aprov_w(nr_proc_aprov_w) := nr_proc_aprov_w;
						tb_nr_nivel_aprovacao_w(nr_proc_aprov_w) := r_C01_w.nr_nivel_aprovacao;
						tb_ie_responsavel_w(nr_proc_aprov_w) := r_C01_w.ie_responsavel;
						tb_nm_usuario_regra_w(nr_proc_aprov_w) := r_C01_w.nm_usuario_regra;
						tb_vl_minimo_w(nr_proc_aprov_w) := r_C01_w.vl_minimo;
						tb_vl_maximo_w(nr_proc_aprov_w) := r_C01_w.vl_maximo;
						tb_qt_minimo_aprovador_w(nr_proc_aprov_w) := r_C01_w.qt_minimo_aprovador;
						tb_qt_itens_regra_w(nr_proc_aprov_w) := r_C01_w.qt_itens_regra;
						tb_qt_intervalo_regra_w(nr_proc_aprov_w) := r_C01_w.qt_intervalo_regra;
						nr_proc_aprov_w := nr_proc_aprov_w + 1;

						if (r_C01_w.cd_cargo IS NOT NULL AND r_C01_w.cd_cargo::text <> '') then
							dt_liberacao_w  := null;
						end if;

					elsif (r_C01_w.ie_responsavel = 'F') then
						cd_responsavel_w := obter_pessoa_fisica_usuario(r_C01_w.nm_usuario_regra,'C');

						if (coalesce(cd_responsavel_w::text, '') = '') then
							/*'O usuario aprovador ' || NM_USUARIO_REGRA_W || 'nao possui nenhuma pessoa fisica vinculada. Favor ajustar o cadastro deste usuario');*/

							CALL wheb_mensagem_pck.exibir_mensagem_abort(191563,'NM_USUARIO_REGRA_W=' ||r_C01_w.nm_usuario_regra);
						end if;

						if (r_C01_w.nr_nivel_aprovacao IS NOT NULL AND r_C01_w.nr_nivel_aprovacao::text <> '') and (coalesce(dt_liberacao_w::text, '') = '') then
							ie_aprovacao_nivel_w := obter_se_proc_por_nivel(nr_seq_aprovacao_w, cd_estabelecimento_w);

							if (ie_aprovacao_nivel_w = 'S') and (nr_nivel_aprovacao_w2 = r_C01_w.nr_nivel_aprovacao) then
								dt_liberacao_w  := clock_timestamp();
							else
								dt_liberacao_w  := null;
							end if;
						end if;
						
						tb_nr_seq_aprov_comp_w(nr_proc_aprov_w) := nr_seq_aprovacao_w;
						tb_nr_seq_proc_aprov_w(nr_proc_aprov_w) := r_C01_w.nr_sequencia;
						tb_cd_pessoa_fisica_w(nr_proc_aprov_w) := cd_responsavel_w;
						tb_cargo_w(nr_proc_aprov_w) := null;
						tb_dt_liberacao_w(nr_proc_aprov_w) := dt_liberacao_w;
						tb_dt_definicao_w(nr_proc_aprov_w) := null;
						tb_ie_aprov_reprov_w(nr_proc_aprov_w) := 'P';
						tb_ie_urgente_w(nr_proc_aprov_w) := 'N';
						tb_nr_documento_w(nr_proc_aprov_w) := nr_seq_proj_rec_p;
						tb_ie_tipo_w(nr_proc_aprov_w) := 'E';
						tb_dt_documento_w(nr_proc_aprov_w) := dt_emissao_w;
						tb_nr_seq_aprov_w(nr_proc_aprov_w) := nr_proc_aprov_w;
						tb_nr_nivel_aprovacao_w(nr_proc_aprov_w) := r_C01_w.nr_nivel_aprovacao;
						tb_ie_responsavel_w(nr_proc_aprov_w) := r_C01_w.ie_responsavel;
						tb_nm_usuario_regra_w(nr_proc_aprov_w) := r_C01_w.nm_usuario_regra;
						tb_vl_minimo_w(nr_proc_aprov_w) := r_C01_w.vl_minimo;
						tb_vl_maximo_w(nr_proc_aprov_w) := r_C01_w.vl_maximo;
						tb_qt_minimo_aprovador_w(nr_proc_aprov_w) := r_C01_w.qt_minimo_aprovador;
						tb_qt_itens_regra_w(nr_proc_aprov_w) := r_C01_w.qt_itens_regra;
						tb_qt_intervalo_regra_w(nr_proc_aprov_w) := r_C01_w.qt_intervalo_regra;
						nr_proc_aprov_w := nr_proc_aprov_w + 1;

						if (cd_responsavel_w IS NOT NULL AND cd_responsavel_w::text <> '') then
							dt_liberacao_w  := null;
						end if;
					end if;
				end if;
			end if;
		end loop;
	end if;
end if;

if (tb_nr_seq_proc_compra_w.count > 0) then	
	forall i in tb_nr_seq_proc_compra_w.first .. tb_nr_seq_proc_compra_w.last
		insert into processo_compra(nr_sequencia, cd_processo_aprov, dt_atualizacao,
			nm_usuario)
		values (tb_nr_seq_proc_compra_w(i), tb_cd_processo_aprov_w(i), clock_timestamp(), 
			nm_usuario_p);
	commit;
	
	forall i in tb_nr_seq_proc_compra_w.first .. tb_nr_seq_proc_compra_w.last
		update	projeto_recurso
		set	nr_seq_aprovacao	= tb_nr_seq_proc_compra_w(i),
			nr_seq_proc_aprov	= tb_cd_processo_aprov_w(i)
		where	nr_sequencia		= nr_seq_proj_rec_p;
	commit;
end if;

if (tb_nr_seq_aprov_w.count > 0) then
	forall i in tb_nr_seq_aprov_w.first .. tb_nr_seq_aprov_w.last
		insert into processo_aprov_compra(
			nr_sequencia, nr_seq_proc_aprov, dt_atualizacao,
			nm_usuario, nm_usuario_nrec, cd_pessoa_fisica,
			cd_cargo, dt_liberacao, dt_definicao,
			ie_aprov_reprov, cd_estabelecimento, ie_urgente,
			nr_documento, ie_tipo, dt_documento,
			nr_nivel_aprovacao, cd_processo_aprov, ie_responsavel,
			vl_minimo, vl_maximo, qt_minimo_aprovador,
			nm_usuario_regra, qt_itens_regra, qt_intervalo_regra)
		values (	tb_nr_seq_aprov_comp_w(i), tb_nr_seq_proc_aprov_w(i), clock_timestamp(),
			nm_usuario_p, nm_usuario_p, tb_cd_pessoa_fisica_w(i),
			tb_cargo_w(i), tb_dt_liberacao_w(i), tb_dt_definicao_w(i),
			tb_ie_aprov_reprov_w(i), cd_estabelecimento_w, tb_ie_urgente_w(i),
			tb_nr_documento_w(i), tb_ie_tipo_w(i), tb_dt_documento_w(i),
			tb_nr_nivel_aprovacao_w(i), tb_cd_processo_aprov_w(i), tb_ie_responsavel_w(i),
			tb_vl_minimo_w(i), tb_vl_maximo_w(i), tb_qt_minimo_aprovador_w(i),
			tb_nm_usuario_regra_w(i), tb_qt_itens_regra_w(i), tb_qt_intervalo_regra_w(i));
	commit;
end if;

for r_C02_w in C02( nr_seq_proj_rec_p ) loop
	CALL aprovacao_automatica_req( r_C02_w.nr_seq_aprovacao, nm_usuario_p);
end loop;

if (coalesce(ie_commit_p,'N') = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_processo_aprov_proj_rec (nr_seq_proj_rec_p projeto_recurso.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, ie_commit_p text ) FROM PUBLIC;

