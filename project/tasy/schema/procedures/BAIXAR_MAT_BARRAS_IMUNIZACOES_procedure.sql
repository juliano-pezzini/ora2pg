-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixar_mat_barras_imunizacoes ( nr_sequencia_p bigint, nr_atendimento_p bigint, cd_material_p bigint, qt_material_p bigint, nm_usuario_p text, nr_seq_lote_fornec_p bigint) AS $body$
DECLARE



ds_erro_w		varchar(600);
dt_entrada_w		timestamp;						
dt_entrada_unidade_w	timestamp;
ie_consignado_w		varchar(1);
cd_fornec_consignado_w	varchar(14);
vl_param_w		varchar(15);
cd_unidade_medida_w	varchar(30)	:= null;
cd_estabelecimento_w	integer	:= wheb_usuario_pck.get_cd_estabelecimento;
cd_setor_atend_User_w	integer	:= 0;
nr_seq_atepacu_W	bigint	:= 0;
qt_total_dispensar_w	double precision	:= 0;
cd_local_estoque_w	bigint	:= 0;
nr_sequencia_w		bigint	:= 0;
cd_convenio_w		integer;
cd_categoria_w		varchar(10);
cd_setor_atend_w	integer	:= 0;
ie_local_valido_w	varchar(1)	:= 'S';
ie_material_ok_w	varchar(1)	:= 'S';
ie_data_conta_w		varchar(1);
cd_setor_atendimento_w	integer	:= 0;



BEGIN
select	obter_dados_material(cd_material_p,'CON')
into STRICT	ie_consignado_w
;

select	max(cd_setor_atendimento)
into STRICT	cd_setor_atend_User_w
from	usuario
where	nm_usuario	=	nm_usuario_p;


vl_param_w := obter_valor_param_usuario(36,1,Obter_Perfil_ativo,nm_usuario_p,cd_estabelecimento_w);
ie_data_conta_w := obter_param_usuario(903, 30, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento, ie_data_conta_w);

if (vl_param_w = 'Usuario') then
	select	obter_local_estoque_setor(wheb_usuario_pck.get_cd_setor_atendimento, cd_estabelecimento_w),
		wheb_usuario_pck.get_cd_setor_atendimento
	into STRICT	cd_local_estoque_w,
		cd_setor_atend_w
	;
else
	select	obter_local_estoque_setor(cd_setor_atendimento, cd_estabelecimento_w),
		cd_setor_atendimento
	into STRICT	cd_local_estoque_w,
		cd_setor_atend_w
	from	paciente_vacina
	where	nr_sequencia	=    nr_sequencia_p;
end if;

ie_local_valido_w := Obter_Local_Valido(cd_estabelecimento_w, cd_local_estoque_w, cd_material_p, '', ie_local_valido_w);

if (ie_local_valido_w = 'N')	then
	--Local de estoque invalido para baixa
	CALL wheb_mensagem_pck.exibir_mensagem_abort(174107,'');

elsif (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
	select	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_w,'UMS'),1,30) cd_unidade_medida_consumo
	into STRICT	cd_unidade_medida_w
	from 	material
	where 	cd_material	= cd_material_p;
	
	qt_total_dispensar_w := qt_material_p;

	if (ie_consignado_w = '1') then
		if (coalesce(cd_fornec_consignado_w::text, '') = '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(174110,'');
			ie_material_ok_w	:= 'N';
		else
			-- Se tiver apenas um fornecedor material consignado ok
			begin
			select	a.cd_fornecedor
			into STRICT	cd_fornec_consignado_w
                      	from	fornecedor_mat_consignado a,
				Material m 
                      	where 	a.cd_material           = m.cd_material_estoque 
                      	and   	a.dt_mesano_referencia  > (clock_timestamp() - interval '60 days') 
                      	and   	m.cd_material           = cd_material_p
                      	group by a.cd_fornecedor 
                      	having count(*) = 1;
			exception
				when others then
				cd_fornec_consignado_w := NULL;
			end;
			if ( coalesce(cd_fornec_consignado_w::text, '') = '') then
				--O material nao podera ser executado porque possui mais de um fornecedor
				CALL wheb_mensagem_pck.exibir_mensagem_abort(174112,'CD_MATERIAL_P='||to_char(cd_material_p));
				ie_material_ok_w :=  'N';
			end if;
		end if;
	end if;
	
	if (ie_material_ok_w = 'S') then
		begin
		
		select	max(dt_entrada_unidade)
		into STRICT	dt_entrada_unidade_w 
		from	atend_paciente_unidade
		where	nr_atendimento		= nr_atendimento_p;
		
		exception
		when others then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(174102,'NR_ATENDIMENTO='||to_char(nr_atendimento_p));
		end;		
		
		if (ie_data_conta_w = 'E') then
			
			select	max(dt_entrada)
			into STRICT	dt_entrada_w
			from	atendimento_paciente
			where	nr_atendimento = nr_atendimento_p;
			
		elsif (ie_data_conta_w = 'A') then
			dt_entrada_w		:= clock_timestamp();
		end if;
		
		select	nextval('material_atend_paciente_seq')
		into STRICT	nr_sequencia_w
		;

		nr_seq_atepacu_w	:= OBTER_ATEPACU_PACIENTE(nr_atendimento_p, 'A');
		cd_convenio_w		:= OBTER_CONVENIO_ATENDIMENTO(nr_atendimento_p);
		cd_categoria_w		:= Obter_Categoria_Atendimento(nr_atendimento_p);
		
		select	max(cd_setor_atendimento)
		into STRICT	cd_setor_atendimento_w
		from	atend_paciente_unidade
		where	nr_seq_interno	= coalesce(nr_seq_atepacu_w,0);
	
		if (cd_setor_atendimento_w <> cd_setor_atend_w) then
			CALL gerar_passagem_setor_atend(nr_atendimento_p, cd_setor_atend_w, dt_entrada_w, 'S', nm_usuario_p);
		
			select	max(nr_seq_interno)
			into STRICT	nr_seq_atepacu_w
			from	atend_paciente_unidade
			where	nr_atendimento 			= nr_atendimento_p
			and	cd_setor_atendimento		= cd_setor_atend_w
			and	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_entrada_unidade) = ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_entrada_w);

		end if;
		
		insert into material_atend_paciente(	nr_sequencia,
							nr_atendimento,
							dt_entrada_unidade,
							dt_atendimento,
							cd_unidade_medida,
							qt_material,
							dt_atualizacao,
							nm_usuario,
							cd_acao,
							cd_setor_atendimento,
							nr_seq_atepacu,
							cd_material,
							cd_convenio,
							cd_categoria,
							cd_local_estoque,
							nr_seq_lote_fornec)
						values (	nr_sequencia_w,
							nr_atendimento_p,
							coalesce(dt_entrada_unidade_w,dt_entrada_w),
							dt_entrada_w,
							cd_unidade_medida_w,
							qt_material_p,
							clock_timestamp(),
							nm_usuario_p,
							'1',
							cd_setor_atend_w,
							nr_seq_atepacu_w,
							cd_material_p,
							cd_convenio_w,
							cd_categoria_w,
							cd_local_estoque_w,
							CASE WHEN nr_seq_lote_fornec_p=0 THEN null  ELSE nr_seq_lote_fornec_p END );
		
		CALL atualiza_preco_material(nr_sequencia_w,nm_usuario_p);
	end if;
	
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixar_mat_barras_imunizacoes ( nr_sequencia_p bigint, nr_atendimento_p bigint, cd_material_p bigint, qt_material_p bigint, nm_usuario_p text, nr_seq_lote_fornec_p bigint) FROM PUBLIC;

