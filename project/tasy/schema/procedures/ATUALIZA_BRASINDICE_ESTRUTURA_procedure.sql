-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_brasindice_estrutura (nr_seq_estrutura_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w		bigint;
cd_material_w		bigint;
ie_atualiza_brasindice_w	varchar(1);
nr_seq_mat_estrutura_w	bigint;
qt_reg_w		bigint;
nr_seq_mat_estr_vig_w	bigint;
dt_final_vigencia_w	timestamp;

cd_versao_w		bigint;
nr_seq_w		bigint;
cd_laboratorio_w        varchar(6);
cd_medicamento_w        varchar(6);
cd_apresentacao_w       varchar(6);
dt_final_vig_w		timestamp;
ie_tipo_brasindice_w	varchar(1);

nr_seq_brasindice_w	bigint;


c04 CURSOR FOR
	SELECT 	cd_material,
		nr_sequencia
	from 	MAT_ESTRUTURA_CADASTRO
	where 	nr_seq_estrutura = nr_seq_estrutura_p;


BEGIN

select 	coalesce(max(ie_atualiza_brasindice),'N')
into STRICT	ie_atualiza_brasindice_w
from 	MAT_ESTRUTURA
where	ie_situacao = 'A'
and 	nr_sequencia = nr_seq_estrutura_p;

if (ie_atualiza_brasindice_w = 'S') then

	open C04;
	loop
	fetch C04 into
		cd_material_w,
		nr_seq_mat_estrutura_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin

		select 	count(*)
		into STRICT	qt_reg_w
		from 	W_BRASINDICE_ESTRUT_INT
		where 	nr_seq_estrutura = nr_seq_estrutura_p
		and 	cd_material = cd_material_w
		and 	nm_usuario = nm_usuario_p;


		if (qt_reg_w = 0) then

			select 	coalesce(max(nr_sequencia),0)
			into STRICT	nr_seq_mat_estr_vig_w
			from 	mat_estrutura_cad_vig
			where 	nr_seq_mat_estrutura = nr_seq_mat_estrutura_w;

			if (nr_seq_mat_estr_vig_w = 0) then
				insert into mat_estrutura_cad_vig(
					NR_SEQUENCIA, NR_SEQ_MAT_ESTRUTURA, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, DT_INICIO_VIGENCIA, DT_FINAL_VIGENCIA)
				values (nextval('mat_estrutura_cad_vig_seq'), nr_seq_mat_estrutura_w , clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p, to_date('01/01/2000','dd/mm/yyyy'), clock_timestamp());
			else
				select 	max(dt_final_vigencia)
				into STRICT	dt_final_vigencia_w
				from 	mat_estrutura_cad_vig
				where 	nr_sequencia = nr_seq_mat_estr_vig_w;

				if (coalesce(dt_final_vigencia_w::text, '') = '') then

					select 	coalesce(max(nr_seq_brasindice),0),
						coalesce(max(ie_tipo_brasindice),'R')
					into STRICT	nr_seq_brasindice_w,
						ie_tipo_brasindice_w
					from 	mat_estrutura_cad_vig
					where 	nr_sequencia = nr_seq_mat_estr_vig_w;

					if (nr_seq_brasindice_w > 0) then

						if (coalesce(ie_tipo_brasindice_w,'R') = 'R') then

							begin
							select 	cd_laboratorio,
								cd_apresentacao,
								cd_medicamento,
								ie_versao_atual
							into STRICT	cd_laboratorio_w,
								cd_apresentacao_w,
								cd_medicamento_w,
								cd_versao_w
							from 	brasindice_restrito_hosp
							where 	nr_sequencia = nr_seq_brasindice_w;
							exception
								when others then
								cd_laboratorio_w	:= '0';
								cd_apresentacao_w	:= '0';
								cd_medicamento_w	:= '0';
								cd_versao_w		:= 0;
							end;

							select 	coalesce(min(nr_sequencia),0)
							into STRICT	nr_seq_w
							from 	brasindice_preco
							where 	cd_medicamento = cd_medicamento_w
							and 	cd_laboratorio = cd_laboratorio_w
							and 	cd_apresentacao = cd_apresentacao_w
							and  	IE_VERSAO_ATUAL > cd_versao_w
							AND  	ie_restrito = 'N';

						elsif (coalesce(ie_tipo_brasindice_w,'R') = 'S') then

							begin
							select 	cd_laboratorio,
								cd_apresentacao,
								cd_medicamento,
								ie_versao_atual
							into STRICT	cd_laboratorio_w,
								cd_apresentacao_w,
								cd_medicamento_w,
								cd_versao_w
							from 	brasindice_solucao
							where 	nr_sequencia = nr_seq_brasindice_w;
							exception
								when others then
								cd_laboratorio_w	:= '0';
								cd_apresentacao_w	:= '0';
								cd_medicamento_w	:= '0';
								cd_versao_w		:= 0;
							end;

							select 	coalesce(min(nr_sequencia),0)
							into STRICT	nr_seq_w
							from 	brasindice_preco
							where 	cd_medicamento = cd_medicamento_w
							and 	cd_laboratorio = cd_laboratorio_w
							and 	cd_apresentacao = cd_apresentacao_w
							and  	IE_VERSAO_ATUAL > cd_versao_w
							AND  	ie_solucao = 'N';

						end if;
					end if;

					dt_final_vig_w:=  clock_timestamp();

					if (nr_seq_w > 0) then
						select 	coalesce(max(dt_inicio_vigencia - 1),dt_final_vig_w)
						into STRICT	dt_final_vig_w
						from 	brasindice_preco
						where 	nr_sequencia = nr_seq_w;

						update 	mat_estrutura_cad_vig
						set 	DT_FINAL_VIGENCIA = dt_final_vig_w
						where 	nr_sequencia = nr_seq_mat_estr_vig_w;

					end if;

				end if;

			end if;

		end if;

		end;
	end loop;
	close C04;

end if;

delete from W_BRASINDICE_ESTRUT_INT;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_brasindice_estrutura (nr_seq_estrutura_p bigint, nm_usuario_p text) FROM PUBLIC;
