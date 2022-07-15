-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_dev_lote_prescricao ( nr_lote_p bigint, cd_motivo_devolucao_p text, ie_opcao_p INOUT text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*
ie_opcao_p
LT = Limpa tabela
GR = Gera registros tabela W
D = Gera devolucao
*/
nr_lote_prescr_w		bigint;
nr_prescricao_w			bigint;
cd_setor_atendimento_w		integer;
cd_setor_atendimento_ant_w	integer := 0;
nr_atendimento_w		bigint;
nr_atendimento_ant_w		bigint := 0;
nr_devolucao_w			bigint;
nr_devolucao_ant_w		bigint := 0;
cd_material_w			bigint;
dt_atendimento_w		timestamp;
cd_unidade_medida_w		varchar(30);
nr_sequencia_prescricao_w	integer;
dt_entrada_unidade_w		timestamp;
nr_seq_atendimento_w		bigint;
cd_local_estoque_w		smallint;
cd_local_padrao_dev_w		smallint;
qt_material_w			double precision;
cd_pessoa_fisica_devol_w	varchar(10) := '';
nr_sequencia_w			bigint;
ie_local_estoque_lote_w		varchar(1);
ie_setor_usuario_w		varchar(1);
nr_interno_conta_w		material_atend_paciente.nr_interno_conta%type;
ie_atend_def_w			varchar(1);

C01 CURSOR FOR
	SELECT	a.nr_seq_lote,
		b.nr_prescricao,
		obter_atendimento_prescr(b.nr_prescricao),
		b.cd_setor_atendimento
	from	w_ap_lote_devolucao a,
		ap_lote b
	where	a.nm_usuario = nm_usuario_p
	and	a.nr_seq_lote = b.nr_sequencia
	order by 3,4;

C02 CURSOR FOR
	SELECT	a.cd_material,
		a.dt_atendimento,
		a.cd_unidade_medida,
		a.nr_sequencia_prescricao,
		a.dt_entrada_unidade,
		a.nr_sequencia,
		a.cd_local_estoque,
		sum(a.qt_material)
	FROM material b, material_em_devolucao_v a
LEFT OUTER JOIN tipo_baixa_prescricao c ON (a.cd_motivo_baixa = c.cd_tipo_baixa AND a.ie_prescr_dev = c.ie_prescricao_devolucao)
WHERE a.cd_material = b.cd_material and a.nr_atendimento = nr_atendimento_w and a.nr_prescricao	= nr_prescricao_w and a.nr_seq_lote_ap = nr_lote_prescr_w   and not exists ( SELECT 1 from item_devolucao_material_pac where nr_seq_lote = nr_lote_prescr_w) GROUP BY a.cd_material,
		a.dt_atendimento,
		a.cd_unidade_medida,
		a.nr_sequencia_prescricao,
		a.dt_entrada_unidade,
		a.nr_sequencia,
		a.cd_local_estoque,
		a.nr_seq_lote_ap;


BEGIN

cd_local_padrao_dev_w := obter_param_usuario(42, 24, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, cd_local_padrao_dev_w);
ie_setor_usuario_w := Obter_Param_Usuario(42, 64, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_setor_usuario_w);
ie_local_estoque_lote_w := obter_param_usuario(42, 90, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_local_estoque_lote_w);
ie_atend_def_w := obter_param_usuario(42, 91, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_atend_def_w);

if	((ie_opcao_p = 'LT' HAVING	sum(a.qt_material) > 0
	) or (ie_opcao_p = 'GR')) and (coalesce(nr_lote_p,0) > 0) then

	if (ie_opcao_p = 'LT') then
		delete	FROM w_ap_lote_devolucao
		where	nm_usuario = nm_usuario_p;
		commit;
	end if;
	
	insert into w_ap_lote_devolucao(nr_seq_lote,nm_usuario) values (nr_lote_p,nm_usuario_p);

elsif (ie_opcao_p = 'D') and (coalesce(nr_lote_p,0) = 0) then

	cd_pessoa_fisica_devol_w := obter_pessoa_fisica_usuario(nm_usuario_p,'C');

	open C01;
	loop
	fetch C01 into	
		nr_lote_prescr_w,
		nr_prescricao_w,
		nr_atendimento_w,
		cd_setor_atendimento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		
		if (coalesce(ie_local_estoque_lote_w,'N') = 'S') then
		
			select	coalesce(max(cd_local_estoque),0)
			into STRICT	cd_local_padrao_dev_w
			from	ap_lote
			where	nr_sequencia = nr_lote_prescr_w;
		
		end if;
		
		open C02;
		loop
		fetch C02 into	
			cd_material_w,
			dt_atendimento_w,
			cd_unidade_medida_w,
			nr_sequencia_prescricao_w,
			dt_entrada_unidade_w,
			nr_seq_atendimento_w,
			cd_local_estoque_w,
			qt_material_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin

			select max(nr_interno_conta)
            into STRICT nr_interno_conta_w
            from material_atend_paciente
            where nr_sequencia = nr_seq_atendimento_w;

			if (ie_atend_def_w = 'N') and obter_status_conta(nr_interno_conta_w,'C') = 2 then
                CALL wheb_mensagem_pck.exibir_mensagem_abort(191276);
			end if;

			if (nr_atendimento_w <> nr_atendimento_ant_w) or (cd_setor_atendimento_w <> cd_setor_atendimento_ant_w) then
				
				if (ie_setor_usuario_w = 'S') then
				
					select	obter_setor_usuario(nm_usuario_p)
					into STRICT	cd_setor_atendimento_w
					;
				
				end if;
				
				select	nextval('devolucao_material_pac_seq')
				into STRICT	nr_devolucao_w
				;
				
				insert into devolucao_material_pac(
					nr_devolucao,
					nr_atendimento,
					dt_entrada_unidade,
					dt_devolucao,
					cd_pessoa_fisica_devol,
					cd_setor_atendimento,
					nm_usuario_devol,
					dt_atualizacao,
					nm_usuario_baixa,
					dt_liberacao_baixa,
					dt_baixa_total,
					nm_usuario,
					dt_impressao,
					dt_entrega_fisica,
					cd_estabelecimento)
				values (nr_devolucao_w,
					nr_atendimento_w,
					dt_entrada_unidade_w,
					clock_timestamp(),
					cd_pessoa_fisica_devol_w,
					cd_setor_atendimento_w,
					nm_usuario_p,
					clock_timestamp(),
					null,
					null,
					null,
					nm_usuario_p,
					null, 
					null,
					cd_estabelecimento_p);
				
			end if;
			
			nr_atendimento_ant_w := nr_atendimento_w;
			cd_setor_atendimento_ant_w := cd_setor_atendimento_w;
			
			select	coalesce(max(nr_sequencia),0) + 1
			into STRICT	nr_sequencia_w
			from	item_devolucao_material_pac
			where	nr_devolucao = nr_devolucao_w;
			
			insert into item_devolucao_material_pac(
				nr_devolucao,
				nr_sequencia,
				cd_material,
				dt_atendimento,
				cd_local_estoque,
				cd_unidade_medida,
				cd_motivo_devolucao,
				dt_atualizacao,
				nm_usuario_devol,
				qt_material,
				nr_prescricao,
				nr_sequencia_prescricao,
				ie_tipo_baixa_estoque,
				dt_entrada_unidade,
				nr_seq_atendimento,
				nr_seq_lote,
				nm_usuario)
			values (	nr_devolucao_w,
				nr_sequencia_w,
				cd_material_w,
				dt_atendimento_w,
				CASE WHEN coalesce(cd_local_padrao_dev_w, 0)=0 THEN cd_local_estoque_w  ELSE cd_local_padrao_dev_w END ,
				cd_unidade_medida_w,
				cd_motivo_devolucao_p,
				clock_timestamp(),
				nm_usuario_p,
				qt_material_w,
				nr_prescricao_w,
				nr_sequencia_prescricao_w,
				0,
				dt_entrada_unidade_w,
				nr_seq_atendimento_w,
				nr_lote_prescr_w,
				nm_usuario_p);
			
			end;
		end loop;
		close C02;
		
		if (nr_devolucao_w <> nr_devolucao_ant_w) then
		
			update	devolucao_material_pac
			set	dt_liberacao_baixa = clock_timestamp()
			where	nr_devolucao = nr_devolucao_w;
		
		end if;

		nr_devolucao_ant_w := nr_devolucao_w;
		
		end;
	end loop;
	close C01;

	if (nr_devolucao_w > 0) then
		
		update	devolucao_material_pac
		set	dt_liberacao_baixa = clock_timestamp()
		where	nr_devolucao = nr_devolucao_w;
	
	end if;
	
end if;

if (ie_opcao_p = 'LT') then
	ie_opcao_p := 'GR';
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_dev_lote_prescricao ( nr_lote_p bigint, cd_motivo_devolucao_p text, ie_opcao_p INOUT text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

