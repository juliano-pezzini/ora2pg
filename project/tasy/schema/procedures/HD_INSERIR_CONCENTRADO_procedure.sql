-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_inserir_concentrado (nr_seq_dialise_p bigint, lista_cd_lote_fornecedor_p text, lista_cd_material_p text, lista_ie_atualiza_estoque_p text, lista_nr_seq_maquina_p text, lista_nr_seq_ponto_acesso_p text, nm_usuario_p text, ie_acao_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

				
qt_material_w			integer;				
ie_estoque_w			varchar(1);
nr_Seq_concentrado_w		bigint;
cd_local_estoque_w		smallint;
cd_oper_perda_etq_w		smallint;
cd_setor_atendimento_w		integer;
cd_unidade_medida_w		varchar(10);
nr_seq_concentrado_ret_w	hd_dialise_concentrado.nr_sequencia%type;
nr_lista_concentrado_w		varchar(2000);
nr_lista_concentrado_ret_w	varchar(2000);
lista_cd_lote_fornecedor_w	dbms_sql.varchar2_table;
lista_cd_material_w		dbms_sql.varchar2_table;
lista_ie_atualiza_estoque_w	dbms_sql.varchar2_table;
lista_nr_seq_maquina_w		dbms_sql.varchar2_table;
lista_nr_seq_ponto_acesso_w	dbms_sql.varchar2_table;
cd_lote_fornecedor_w		hd_dialise_concentrado.cd_lote_fornecedor%type;
cd_material_w			hd_dialise_concentrado.cd_material%type;
ie_atualiza_estoque_w		varchar(1);
nr_seq_maquina_w		hd_dialise_concentrado.nr_seq_maquina%type;
nr_seq_ponto_acesso_w		hd_dialise_concentrado.nr_seq_ponto_acesso%type;
nr_atendimento_w hd_dialise.nr_atendimento%type;

c01 CURSOR FOR
	SELECT	nr_sequencia
	from	hd_dialise_concentrado
	where	nr_seq_maquina		=	nr_seq_maquina_w
	and	nr_seq_ponto_acesso	=	nr_seq_ponto_acesso_w
	and	coalesce(dt_retirada::text, '') = '';

BEGIN

if (ie_acao_p = 'S') and (lista_nr_seq_maquina_p IS NOT NULL AND lista_nr_seq_maquina_p::text <> '') then

	lista_nr_seq_maquina_w 		:= obter_lista_string(lista_nr_seq_maquina_p, ',');
	lista_nr_seq_ponto_acesso_w 	:= obter_lista_string(lista_nr_seq_ponto_acesso_p, ',');
	for	i in lista_nr_seq_maquina_w.first..lista_nr_seq_maquina_w.last loop
		nr_seq_maquina_w 		:= (lista_nr_seq_maquina_w(i))::numeric;

		begin
			nr_seq_ponto_acesso_w 	:= (lista_nr_seq_ponto_acesso_w(i))::numeric;
		exception
		when others then
			nr_seq_ponto_acesso_w 	:= null;
		end;
		
		open	c01;
		loop
		fetch	c01 into
			nr_seq_concentrado_ret_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */
			
			if (coalesce(nr_lista_concentrado_ret_w::text, '') = '') then
				nr_lista_concentrado_ret_w 	:= to_char(nr_seq_concentrado_ret_w);
			elsif (length(nr_lista_concentrado_ret_w || ',' || to_char(nr_seq_concentrado_ret_w)) < 2000) then
				nr_lista_concentrado_ret_w 	:= nr_lista_concentrado_ret_w || ',' || to_char(nr_seq_concentrado_ret_w);
			end if;

		end loop;
		close c01;
		
		update	HD_DIALISE_CONCENTRADO
		set	dt_retirada 		= 	clock_timestamp(),
			cd_pf_retirada		=	substr(obter_pessoa_fisica_usuario(nm_usuario_p,'C'),1,10)
		where	nr_seq_maquina		=	nr_seq_maquina_w
		and	nr_seq_ponto_acesso	=	nr_seq_ponto_acesso_w
		and	coalesce(dt_retirada::text, '') = '';

	end loop;
	
end if;
		
		
		

if (lista_cd_material_p IS NOT NULL AND lista_cd_material_p::text <> '') then
	
	lista_cd_lote_fornecedor_w 	:= obter_lista_string(lista_cd_lote_fornecedor_p, ',');
	lista_ie_atualiza_estoque_w 	:= obter_lista_string(lista_ie_atualiza_estoque_p, ',');
	lista_nr_seq_maquina_w 		:= obter_lista_string(lista_nr_seq_maquina_p, ',');
	lista_nr_seq_ponto_acesso_w 	:= obter_lista_string(lista_nr_seq_ponto_acesso_p, ',');
	lista_cd_material_w 		:= obter_lista_string(lista_cd_material_p, ',');
	for	i in lista_cd_material_w.first..lista_cd_material_w.last loop
		cd_material_w 		:= (lista_cd_material_w(i))::numeric;
		
		begin
			cd_lote_fornecedor_w 	:= (lista_cd_lote_fornecedor_w(i))::numeric;
		exception
		when others then
			cd_lote_fornecedor_w 	:= null;
		end;
		
		begin
			ie_atualiza_estoque_w 	:= lista_ie_atualiza_estoque_w(i);
		exception
		when others then
			ie_atualiza_estoque_w 	:= null;
		end;
		
		begin
			nr_seq_maquina_w 	:= (lista_nr_seq_maquina_w(i))::numeric;
		exception
		when others then
			nr_seq_maquina_w	:= null;
		end;
		
		begin
			nr_seq_ponto_acesso_w 	:= (lista_nr_seq_ponto_acesso_w(i))::numeric;
		exception
		when others then
			nr_seq_ponto_acesso_w 	:= null;
		end;

		
				
		select 	nextval('hd_dialise_concentrado_seq')
		into STRICT	nr_Seq_concentrado_w
		;

		insert into hd_dialise_concentrado(	nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							ie_atualiza_estoque,
							nr_seq_dialise,
							cd_lote_fornecedor,
							cd_material,
							dt_inclusao,
							nr_seq_maquina,
							nr_seq_ponto_acesso,
							cd_pf_inclusao)
		values (					nr_Seq_concentrado_w,
							clock_timestamp(),
							nm_usuario_p,
							clock_timestamp(),					
							nm_usuario_p,
							ie_atualiza_estoque_w,
							nr_seq_dialise_p,
							cd_lote_fornecedor_w,
							cd_material_w,
							clock_timestamp(),
							nr_seq_maquina_w,
							nr_seq_ponto_acesso_w,
							substr(obter_pessoa_fisica_usuario(nm_usuario_p,'C'),1,10));

		if (coalesce(nr_lista_concentrado_w::text, '') = '') then
			nr_lista_concentrado_w 	:= to_char(nr_Seq_concentrado_w);
		elsif (length(nr_lista_concentrado_w || ',' || to_char(nr_Seq_concentrado_w)) < 2000) then
			nr_lista_concentrado_w 	:= nr_lista_concentrado_w || ',' || to_char(nr_Seq_concentrado_w);
		end if;
		
		qt_material_w	:= 1;
							
		if (ie_atualiza_estoque_w = 'S') then

			select	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_p,'UME'),1,30) cd_unidade_medida_estoque
			into STRICT	cd_unidade_medida_w
			from	material
			where	cd_material = cd_material_w;

			select	max(cd_local_estoque),
				max(cd_oper_perda_etq),
				max(cd_setor_atendimento)
			into STRICT	cd_local_estoque_w,
				cd_oper_perda_etq_w,
				cd_setor_atendimento_w
			from	hd_estoque_concentrado
			where	cd_estabelecimento = cd_estabelecimento_p;

			
			ie_estoque_w := Obter_Disp_estoque(	cd_material_w, cd_local_estoque_w, cd_estabelecimento_p, 0, qt_material_w, '', ie_estoque_w);
			if (ie_estoque_w = 'S') then		
				begin
				
				if (coalesce(cd_local_estoque_w::text, '') = '') then
					--O movimento de estoque nao sera gerado devido a nao existir regra de local de estoque do concentrado cadastrada. Favor verificar!
					CALL wheb_mensagem_pck.exibir_mensagem_abort(178168);
				end if;
			
			SELECT	max(nr_atendimento)
			INTO STRICT 	nr_atendimento_w 
			FROM 	hd_dialise 
			where nr_sequencia = nr_seq_dialise_p;

				insert into movimento_estoque(
					nr_movimento_estoque,		cd_estabelecimento,
					cd_local_estoque,		dt_movimento_estoque,
					cd_operacao_estoque,		cd_acao,
					cd_material,			cd_unidade_med_mov,
					qt_movimento,			dt_mesano_referencia,
					dt_atualizacao,			nm_usuario,
					ie_origem_documento,		nr_documento,
					cd_unidade_medida_estoque,	cd_setor_atendimento,
					qt_estoque,			ds_observacao,
					nr_atendimento,			nr_prescricao,
					nr_seq_lote_fornec)
				values (nextval('movimento_estoque_seq'),	cd_estabelecimento_p,
					cd_local_estoque_w,		clock_timestamp(),
					cd_oper_perda_etq_w,		'1',
					cd_material_w,			cd_unidade_medida_w,
					qt_material_w,			clock_timestamp(),
					clock_timestamp(),				nm_usuario_p,
					'13',				nr_Seq_concentrado_w,
					cd_unidade_medida_w,		cd_setor_atendimento_w,
					qt_material_w,			'HD_inserir_concentrado - Seq ' || nr_Seq_concentrado_w,
					nr_atendimento_w,			null,
					cd_lote_fornecedor_w);
				end;
			end if;
		end if;



		
	end loop;
			
end if;

if (ie_acao_p <> 'S') then
	CALL hd_gerar_assinatura(null, nr_lista_concentrado_w, nr_seq_dialise_p, null, null, null, null, null, null, 'IC', nm_usuario_p, 'N');
else
	CALL hd_gerar_assinatura(null, nr_lista_concentrado_w, nr_seq_dialise_p, null, null, null, null, nr_lista_concentrado_ret_w, null, 'SC', nm_usuario_p, 'N');
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_inserir_concentrado (nr_seq_dialise_p bigint, lista_cd_lote_fornecedor_p text, lista_cd_material_p text, lista_ie_atualiza_estoque_p text, lista_nr_seq_maquina_p text, lista_nr_seq_ponto_acesso_p text, nm_usuario_p text, ie_acao_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
