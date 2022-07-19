-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_pos_estab_partic ( nr_seq_conta_pos_p bigint, ie_commit_p text, nm_usuario_p text) AS $body$
DECLARE


/*
	Rotina utilizada na NOVA geração de PÓS-ESTABELECIDO.
*/
vl_benef_proc_w			double precision;
vl_total_part_pos_w		double precision := 0;
vl_total_adicionais_w		double precision := 0;
vl_total_w			double precision := 0;
vl_diferenca_w			double precision := 0;
vl_dif_taxa_w			double precision := 0;
nr_seq_conta_proc_w		pls_conta_proc.nr_sequencia%type;
vl_part_pos_w			pls_conta_pos_proc_part.vl_participante_pos%type;
nr_seq_pos_estab_partic_w	pls_conta_pos_proc_part.nr_sequencia%type;
vl_administracao_w		pls_conta_pos_estab_partic.vl_administracao%type;
tx_administracao_w		pls_conta_pos_estabelecido.tx_administracao%type;
vl_taxa_servico_w		pls_conta_pos_estabelecido.vl_taxa_servico%type;
vl_administracao_part_w		pls_conta_pos_estab_partic.vl_administracao%type;
qt_item_w			pls_conta_pos_estabelecido.qt_item%type;
qt_procedimento_imp_w		pls_conta_proc.qt_procedimento_imp%type;
vl_pos_estab_w			pls_proc_participante.vl_pos_estab%type;
qt_ocor_partic_w		integer;
qt_pos_estab_w			integer;

c01 CURSOR(nr_seq_conta_proc_pc	pls_conta_proc.nr_sequencia%type)FOR
	SELECT	a.nr_sequencia,
		coalesce(a.vl_pos_estab,0) vl_pos_estab
	from	pls_proc_participante	a
	where	a.nr_seq_conta_proc	= nr_seq_conta_proc_pc
	and	((a.ie_status 	<> 'C') or (coalesce(a.ie_status::text, '') = ''))
	and	not exists (SELECT	1
				from	pls_conta_pos_proc_part	b
				where	b.nr_seq_proc_partic = a.nr_sequencia);

C02 CURSOR(nr_seq_conta_pos_pc		pls_conta_pos_estabelecido.nr_sequencia%type) FOR
	SELECT 	nr_sequencia,
		vl_participante_pos
	from	pls_conta_pos_proc_part
	where	nr_seq_conta_pos_proc	= nr_seq_conta_pos_pc
	and	vl_participante_pos	> 0;
BEGIN

	delete 	FROM pls_conta_pos_proc_part
	where	nr_seq_conta_pos_proc = nr_seq_conta_pos_p;

	select	max(nr_seq_conta_proc),
		max(tx_administracao),
		max(coalesce(vl_medico,0) + coalesce(vl_lib_taxa_servico,0)),
		max(coalesce(vl_materiais,0) + coalesce(vl_custo_operacional,0) + coalesce(vl_lib_taxa_co,0) + coalesce(vl_lib_taxa_material,0) + coalesce(vl_medico,0)),
		max(vl_lib_taxa_servico),
		max(qt_item)
	into STRICT	nr_seq_conta_proc_w,
		tx_administracao_w,
		vl_benef_proc_w,
		vl_total_adicionais_w,
		vl_taxa_servico_w,
		qt_item_w
	from	pls_conta_pos_proc
	where	nr_sequencia = nr_seq_conta_pos_p;

	select	max(qt_procedimento_imp)
	into STRICT	qt_procedimento_imp_w
	from	pls_conta_proc
	where	nr_sequencia	= nr_seq_conta_proc_w;

	if (coalesce(qt_procedimento_imp_w::text, '') = '') then
		qt_procedimento_imp_w	:= 1;
	end if;

	if (coalesce(qt_item_w::text, '') = '') then
		qt_item_w	:= 1;
	end if;

	if (coalesce(tx_administracao_w::text, '') = '') then
		tx_administracao_w	:= 0;
	end if;

	--Cursor que irá gerar os participante vinculados ao registro de pós_estabelecido
	for r_c01_w in C01(nr_seq_conta_proc_w) loop

		select	count(1)
		into STRICT	qt_ocor_partic_w
		from	pls_ocorrencia_benef a,
			pls_ocorrencia b
		where	b.nr_sequencia = a.nr_seq_ocorrencia
		and	a.nr_seq_proc_partic = r_c01_w.nr_sequencia
		and	a.ie_situacao = 'A'
		and	b.ie_glosar_faturamento = 'S';

		if (qt_ocor_partic_w = 0) then

			vl_pos_estab_w	:= r_c01_w.vl_pos_estab;
			if (qt_item_w 	!= qt_procedimento_imp_w) and (qt_item_w <> 0) then
				vl_pos_estab_w	:= dividir_sem_round(coalesce(vl_pos_estab_w,0) ,qt_procedimento_imp_w) * qt_item_w;
			end if;

			vl_part_pos_w 		:= vl_pos_estab_w + dividir((vl_pos_estab_w * tx_administracao_w),100);
			vl_administracao_w	:= vl_part_pos_w - vl_pos_estab_w;

			insert into pls_conta_pos_proc_part(nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_conta_pos_proc,
					nr_seq_proc_partic,
					vl_participante_pos,
					vl_administracao)
			values (	nextval('pls_conta_pos_proc_part_seq'),
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_conta_pos_p,
					r_c01_w.nr_sequencia,
					coalesce(vl_part_pos_w,0),
					coalesce(vl_administracao_w,0))
			returning nr_sequencia into nr_seq_pos_estab_partic_w;
		end if;

	end loop;

	select 	count(1)
	into STRICT	qt_pos_estab_w
	from	pls_conta_pos_proc_part
	where	nr_seq_conta_pos_proc	= nr_seq_conta_pos_p;

	if (qt_pos_estab_w	> 0) and (coalesce(vl_benef_proc_w,0) > 0) then

		-- Ajuste no valor final
		select	sum(coalesce(vl_participante_pos,0)),
			sum(coalesce(vl_administracao,0))
		into STRICT	vl_total_part_pos_w,
			vl_administracao_part_w
		from	pls_conta_pos_proc_part
		where	nr_seq_conta_pos_proc = nr_seq_conta_pos_p;

		vl_total_w 	:= (vl_total_part_pos_w + vl_total_adicionais_w);
		vl_diferenca_w 	:= coalesce(vl_benef_proc_w,0) - coalesce(vl_total_w,0);
		vl_dif_taxa_w	:= coalesce(vl_taxa_servico_w,0) - coalesce(vl_administracao_part_w,0);

		if (vl_dif_taxa_w	!= 0) then
			if (qt_pos_estab_w	> 1) then
				for r_c02_w in C02(nr_seq_conta_pos_p) loop
					begin

					if (vl_dif_taxa_w != 0) then

						update	pls_conta_pos_proc_part
						set	vl_administracao	= vl_administracao + vl_dif_taxa_w
						where	nr_sequencia 		= r_c02_w.nr_sequencia;

						vl_dif_taxa_w	:= 0;
					end if;

					end;
				end loop;
			else
				update	pls_conta_pos_proc_part
				set	vl_participante_pos 	= vl_participante_pos +vl_dif_taxa_w,
					vl_administracao	= vl_administracao + vl_dif_taxa_w
				where	nr_sequencia 		= nr_seq_pos_estab_partic_w;
			end if;
		end if;

		--necessário fazer o tratamento para retiar o valor de diferença após ter tirado  valor de diferença da taxa de intercâmbio
		select	sum(coalesce(vl_participante_pos,0))
		into STRICT	vl_total_part_pos_w
		from	pls_conta_pos_proc_part
		where	nr_seq_conta_pos_proc = nr_seq_conta_pos_p;

		vl_diferenca_w 	:= coalesce(vl_benef_proc_w,0) - coalesce(vl_total_part_pos_w,0);
		if (vl_diferenca_w	!= 0) then
			if (qt_pos_estab_w	> 1) then

				for r_c02_w in C02(nr_seq_conta_pos_p) loop
					if (vl_diferenca_w != 0) then

						update	pls_conta_pos_proc_part
						set	vl_participante_pos 	= vl_participante_pos + vl_diferenca_w
						where	nr_sequencia 		= r_c02_w.nr_sequencia;

						vl_diferenca_w	:= 0;
					end if;
				end loop;
			else
				update	pls_conta_pos_proc_part
				set	vl_participante_pos 	= vl_participante_pos + vl_diferenca_w
				where	nr_sequencia 		= nr_seq_pos_estab_partic_w;
			end if;
		end if;

	end if;

	if (ie_commit_p = 'S') then
		commit;
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_pos_estab_partic ( nr_seq_conta_pos_p bigint, ie_commit_p text, nm_usuario_p text) FROM PUBLIC;

