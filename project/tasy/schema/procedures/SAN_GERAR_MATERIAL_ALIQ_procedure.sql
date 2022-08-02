-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_gerar_material_aliq ( nr_seq_transfusao_p bigint, nr_seq_producao_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
 
ds_erro_w		varchar(600);
dt_entrada_w		timestamp;						
dt_entrada_unidade_w	timestamp;
ie_consignado_w		varchar(1);
cd_fornec_consignado_w	varchar(14);
ie_local_w		varchar(15);
cd_unidade_medida_w	varchar(30)	:= null;
cd_estabelecimento_w	integer	:= wheb_usuario_pck.get_cd_estabelecimento;
cd_setor_atend_User_w	integer	:= 0;
nr_seq_atepacu_W	bigint	:= 0;
cd_local_estoque_w	bigint;
nr_sequencia_w		bigint	:= 0;
cd_convenio_w		integer;
cd_categoria_w		varchar(10);
cd_setor_atend_w	integer	:= 0;
ie_local_valido_w	varchar(1)	:= 'S';
ie_material_ok_w	varchar(1)	:= 'S';
nr_atendimento_w	bigint;
cd_material_w		bigint;
qt_material_w		double precision;
nr_seq_tipo_baixa_w	bigint;
ie_baixa_estoque_w	varchar(1)	:= 'S';
nr_seq_transfusao_w	bigint;
nr_seq_lote_fornec_w	bigint;

C01 CURSOR FOR 
	SELECT	cd_material, 
		qt_material, 
		nr_seq_lote_fornec 
	from	material_atend_paciente 
	where	nr_seq_transfusao = nr_seq_transfusao_w 
	and	San_obter_se_regra_material(cd_material,'F') = 'S';

C02 CURSOR FOR 
	SELECT	distinct 
		a.nr_seq_transfusao 
	from	san_producao a 
	where	(a.nr_seq_transfusao IS NOT NULL AND a.nr_seq_transfusao::text <> '') 
	and (a.nr_seq_prod_origem = nr_seq_producao_p 
	or	exists (	SELECT	1 
			from	san_producao b 
			where	a.nr_sequencia = b.nr_seq_prod_origem 
			and	b.nr_sequencia = nr_seq_producao_p));
	

BEGIN 
select	max(cd_setor_atendimento) 
into STRICT	cd_setor_atend_User_w  
from	usuario 
where	nm_usuario = nm_usuario_p;
 
select	max(nr_atendimento) 
into STRICT	nr_atendimento_w 
from	san_transfusao 
where	nr_sequencia = nr_seq_transfusao_p;
 
if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then 
 
	select	max(dt_entrada) 
	into STRICT	dt_entrada_w 
	from	atendimento_paciente 
	where	nr_atendimento = nr_atendimento_w;
 
	select	max(cd_setor_atendimento), 
		max(dt_entrada_unidade) 
	into STRICT	cd_setor_atend_w, 
		dt_entrada_unidade_w 
	from	atend_paciente_unidade 
	where	nr_seq_interno = (SELECT Obter_Atepacu_paciente(nr_atendimento_w, 'A') );
 
	if (coalesce(cd_setor_atend_w::text, '') = '') then 
		CALL gravar_log_tasy(99883, wheb_mensagem_pck.get_texto(798504) || ': '||nr_atendimento_w||'. ' || wheb_mensagem_pck.get_texto(791958) || ': '|| nr_seq_transfusao_p,nm_usuario_p);
	else 
		nr_seq_atepacu_w	:= Obter_Atepacu_paciente(nr_atendimento_w, 'A');
		cd_convenio_w		:= obter_convenio_atendimento(nr_atendimento_w);
		cd_categoria_w		:= obter_categoria_atendimento(nr_atendimento_w);
 
		select	max(nr_seq_tipo_baixa) 
		into STRICT	nr_seq_tipo_baixa_w 
		from	san_parametro 
		where	cd_estabelecimento = cd_estabelecimento_w;
 
		if (nr_seq_tipo_baixa_w IS NOT NULL AND nr_seq_tipo_baixa_w::text <> '') then 
			select	coalesce(max(ie_atualiza_estoque),'S') 
			into STRICT	ie_baixa_estoque_w 
			from	tipo_baixa_prescricao 
			where	nr_sequencia = nr_seq_tipo_baixa_w 
			and	ie_prescricao_devolucao	= 'P';
		end if;
 
		if (ie_baixa_estoque_w = 'S') then 
			ie_local_w := obter_valor_param_usuario(24,14,Obter_Perfil_ativo,nm_usuario_p,cd_estabelecimento_w);
 
			if (upper(ie_local_w) = 'USUARIO') then 
				select	obter_local_estoque_setor(cd_setor_atend_User_w, cd_estabelecimento_w) 
				into STRICT	cd_local_estoque_w	 
				;
			else 
				cd_local_estoque_w := obter_local_estoque_setor(cd_setor_atend_w, cd_estabelecimento_w);
			end if;
		else 
			cd_local_estoque_w := null;
		end if;
 
		open C02;
		loop 
		fetch C02 into	 
			nr_seq_transfusao_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin 
			 
			open C01;
			loop 
			fetch C01 into	 
				cd_material_w, 
				qt_material_w, 
				nr_seq_lote_fornec_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin 
				ie_material_ok_w := 'S';
				ie_consignado_w := obter_dados_material(cd_material_w,'CON');	
 
				if (cd_local_estoque_w IS NOT NULL AND cd_local_estoque_w::text <> '') then 
					ie_local_valido_w := Obter_Local_Valido(cd_estabelecimento_w, cd_local_estoque_w, cd_material_w, '', ie_local_valido_w);
 
					if (ie_local_valido_w = 'N') then 
						CALL gravar_log_tasy(99883, wheb_mensagem_pck.get_texto(798500) || '. '|| wheb_mensagem_pck.get_texto(791958) || ': ' || nr_seq_transfusao_p || 
									', ' || wheb_mensagem_pck.get_texto(798501) || ': ' || cd_material_w || ', ' || wheb_mensagem_pck.get_texto(798502) || ': ' || cd_local_estoque_w, nm_usuario_p);
						ie_material_ok_w := 'N';
					end if;
				end if;	
				 
				if (ie_material_ok_w = 'S') then 
					 
					cd_unidade_medida_w := substr(obter_dados_material_estab(cd_material_w,cd_estabelecimento_w,'UMS'),1,30);
 
					if (ie_consignado_w = '1') then 
						if (coalesce(cd_fornec_consignado_w::text, '') = '') then 
							CALL gravar_log_tasy(99883, wheb_mensagem_pck.get_texto(798503) || '. ' || wheb_mensagem_pck.get_texto(791958) || ': ' || nr_seq_transfusao_p || 
										', ' || wheb_mensagem_pck.get_texto(798501) || ': '|| cd_material_w || ', ' || wheb_mensagem_pck.get_texto(798502) || ': ' || cd_local_estoque_w, nm_usuario_p);
							ie_material_ok_w := 'N';
						else 
							-- Se tiver apenas um fornecedor material consignado ok 
							begin 
							select	a.cd_fornecedor 
							into STRICT	cd_fornec_consignado_w 
							from	fornecedor_mat_consignado a, 
								Material m 
							where 	a.cd_material      = m.cd_material_estoque 
							and  	a.dt_mesano_referencia > (clock_timestamp() - interval '60 days') 
							and  	m.cd_material      = cd_material_w 
							group by a.cd_fornecedor 
							having count(*) = 1;
							exception 
								when others then 
								cd_fornec_consignado_w := NULL;
							end;
							if (coalesce(cd_fornec_consignado_w::text, '') = '') then 
								CALL gravar_log_tasy(99883, wheb_mensagem_pck.get_texto(798505) || '. ' || wheb_mensagem_pck.get_texto(791958) || ': ' || nr_seq_transfusao_p || 
										    ', ' || wheb_mensagem_pck.get_texto(798501) || ': '|| cd_material_w || ', ' || wheb_mensagem_pck.get_texto(798502) || ': ' || cd_local_estoque_w, nm_usuario_p);
								ie_material_ok_w := 'N';
							end if;
						end if;
					end if;
					 
					if (ie_material_ok_w = 'S') then 
						begin 
						 
						select	nextval('material_atend_paciente_seq') 
						into STRICT	nr_sequencia_w 
						;
 
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
											nr_seq_tipo_baixa, 
											nr_seq_transfusao, 
											nr_seq_lote_fornec) 
										values (	nr_sequencia_w, 
											nr_atendimento_w, 
											dt_entrada_unidade_w, 
											dt_entrada_w, 
											cd_unidade_medida_w, 
											qt_material_w, 
											clock_timestamp(), 
											nm_usuario_p, 
											'1', 
											cd_setor_atend_w, 
											nr_seq_atepacu_w, 
											cd_material_w, 
											cd_convenio_w, 
											cd_categoria_w, 
											cd_local_estoque_w, 
											nr_seq_tipo_baixa_w, 
											nr_seq_transfusao_p, 
											nr_seq_lote_fornec_w);
						 
						CALL atualiza_preco_material(nr_sequencia_w,nm_usuario_p);
						end;
					end if;			
				end if;
				 
				end;
			end loop;
			close C01;
			 
			end;
		end loop;
		close C02;		
	end if;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_gerar_material_aliq ( nr_seq_transfusao_p bigint, nr_seq_producao_p bigint, nm_usuario_p text) FROM PUBLIC;

