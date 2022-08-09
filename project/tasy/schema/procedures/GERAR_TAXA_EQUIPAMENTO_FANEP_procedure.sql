-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_taxa_equipamento_fanep ( cd_estabelecimento_p bigint, nr_seq_equipamento_p bigint, nm_usuario_p text ) AS $body$
DECLARE


cd_equipamento_w		bigint;
nr_seq_classif_equip_w	bigint;
nr_seq_proc_w		bigint;
nr_seq_proc_interno_w	bigint;
nr_cirurgia_w		bigint;
nr_seq_taxa_w		bigint;
nr_atendimento_w		bigint;
cd_convenio_w		integer;
ie_insere_taxa_w		varchar(1);
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;
nr_seq_pepo_w		varchar(10);
cd_grupo_proc_w		bigint:=0;
cd_especialidade_w	bigint:=0;
cd_area_procedimento_w	bigint:=0;
cd_procedimento_ww	bigint;
ie_origem_proced_ww	bigint;
qt_equipamento_w		bigint;
ie_gera_quantidade_w	varchar(1);
ds_lista_nao_atualiza_qtd_w varchar(255);


C01 CURSOR FOR
	SELECT	nr_seq_proc_interno,
		nr_sequencia,
		cd_procedimento,
		ie_origem_proced
	from	taxa_equipamento
	where	coalesce(cd_equipamento,cd_equipamento_w)				= cd_equipamento_w
	and	coalesce(nr_seq_classif_equip, coalesce(nr_seq_classif_equip_w,0))	= coalesce(nr_seq_classif_equip_w,0)
	and	cd_estabelecimento 						= cd_estabelecimento_p;

C02 CURSOR FOR
SELECT	nr_atendimento,
	obter_convenio_atendimento(nr_atendimento)
from	pepo_cirurgia
where (nr_sequencia  = nr_seq_pepo_w);


BEGIN
ie_gera_quantidade_w := Obter_Param_Usuario(10026, 15, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_gera_quantidade_w);
ds_lista_nao_atualiza_qtd_w := Obter_Param_Usuario(10026, 17, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ds_lista_nao_atualiza_qtd_w);

if (coalesce(nr_seq_equipamento_p,0) > 0) then
	select	nr_cirurgia,
		nr_seq_pepo,
		cd_equipamento,
		campo_numerico(obter_dados_equipamento(cd_equipamento,'C')),
		qt_equipamento
	into STRICT	nr_cirurgia_w,
		nr_seq_pepo_w,
		cd_equipamento_w,
		nr_seq_classif_equip_w,
		qt_equipamento_w
	from	equipamento_cirurgia
	where	nr_sequencia	=	nr_seq_equipamento_p
	and	coalesce(ie_situacao,'A') = 'A';

	-- Equipamentos que terão excessões, neste a quantidade será nula na taxa
	if (ie_gera_quantidade_w = 'S') and (ds_lista_nao_atualiza_qtd_w IS NOT NULL AND ds_lista_nao_atualiza_qtd_w::text <> '') and (obter_se_contido_char(cd_equipamento_w,ds_lista_nao_atualiza_qtd_w) = 'S') then
		ie_gera_quantidade_w := 'N';
	end if;


	if (nr_seq_pepo_w > 0) then
		open C02;
		loop
		fetch C02 into
			nr_atendimento_w,
			cd_convenio_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin

-- Equipamentos que terão excessões, neste a quantidade será nula na taxa
			if (ie_gera_quantidade_w = 'S') and (ds_lista_nao_atualiza_qtd_w IS NOT NULL AND ds_lista_nao_atualiza_qtd_w::text <> '') and (obter_se_contido_char(cd_equipamento_w,ds_lista_nao_atualiza_qtd_w) = 'S') then
				ie_gera_quantidade_w := 'N';
			end if;

			open C01;
			loop
			fetch C01 into
				nr_seq_proc_interno_w,
				nr_seq_taxa_w,
				cd_procedimento_w,
				ie_origem_proced_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin


				select	coalesce(max('N'),'S')
				into STRICT	ie_insere_taxa_w
				from	convenio_taxa_equipamento
				where	nr_seq_taxa = nr_seq_taxa_w;

				if (ie_insere_taxa_w = 'N') then
					select	coalesce(max('S'),'N')
					into STRICT	ie_insere_taxa_w
					from	convenio_taxa_equipamento
					where	nr_seq_taxa = nr_seq_taxa_w
					and	cd_convenio = cd_convenio_w;
				end if;

				if (ie_insere_taxa_w = 'S') then
					insert into taxa_equipamento_cirurgia(
						nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_proc_interno,
						nr_seq_equi_cir,
						cd_procedimento,
						ie_origem_proced,
						qt_taxa)
					SELECT	nextval('taxa_equipamento_cirurgia_seq'),
						clock_timestamp(),
						nm_usuario_p,
						clock_timestamp(),
						nm_usuario_p,
						nr_seq_proc_interno_w,
						nr_seq_equipamento_p,
						cd_procedimento_w,
						ie_origem_proced_w,
						CASE WHEN ie_gera_quantidade_w='S' THEN qt_equipamento_w  ELSE null END
					;
				end if;
				end;
			end loop;
			close C01;
			end;
		end loop;
		close c02;
	end if;
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_taxa_equipamento_fanep ( cd_estabelecimento_p bigint, nr_seq_equipamento_p bigint, nm_usuario_p text ) FROM PUBLIC;
