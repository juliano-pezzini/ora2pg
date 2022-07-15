-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE intpd_recebe_material_med ( nr_sequencia_p bigint, xml_p xml) AS $body$
DECLARE


_ora2pg_r RECORD;
requisicao_material_w	requisicao_material%rowtype;
item_requisicao_material_w	item_requisicao_material%rowtype;

ie_conversao_w		intpd_eventos_sistema.ie_conversao%type;
nr_seq_projeto_xml_w	intpd_eventos_sistema.nr_seq_projeto_xml%type;
nr_seq_sistema_w		intpd_eventos_sistema.nr_seq_sistema%type;
ie_sistema_externo_w	varchar(15);
reg_integracao_w		gerar_int_padrao.reg_integracao_conv;
nr_seq_regra_w		conversao_meio_externo.nr_seq_regra%type;
ds_erro_w		varchar(4000);
i			integer;
ie_tipo_operacao_w	varchar(3);
qt_existe_w		bigint;
cd_tipo_motivo_baixa_w	bigint;
nr_sequencia_item_ww	bigint;

cd_material_w			material.cd_material%type;
qt_material_w			double precision;
nr_seq_lote_fornec_w	material_lote_fornec.nr_sequencia%type;
nr_seq_loteagrup_w		bigint;
cd_kit_mat_w			integer;
ds_validade_w			varchar(10);
ds_material_w			varchar(255);
cd_unid_med_w			varchar(30);
nr_etiqueta_lp_w		varchar(10);
qt_minutos_w			bigint;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
nm_usuario_w			usuario.nm_usuario%type;
cd_perfil_w				perfil.cd_perfil%type;
qt_mat_requititada_w	item_requisicao_material.qt_material_requisitada%type;
ie_atend_qt_maior_req_w		varchar(1);
cd_mat_barras_w			varchar(255);
cd_mat_req_w			bigint;

/*'Efetua a consulta transformando o elemento XML num tipo de tabela'*/

c01 CURSOR FOR
SELECT	*
from	xmltable('/STRUCTURE/REQUISICAO' passing xml_p columns				/* ****TABELA REFERENCIA****  */
	IE_ACAO				varchar(1)	path	'IE_ACTION', 		/*item_requisicao_material*/
	NR_REQUISICAO			bigint	path	'NR_REQUEST',		/*item_requisicao_material*/
	CD_PERFIL				bigint	path	'CD_PROFILE',		
	xml_itens_valor			xml		path	'ITENS');
	
c01_w	c01%rowtype;

/*'Efetua a consulta transformando o elemento XML num tipo de tabela'*/

c02 CURSOR FOR
SELECT	*
from	xmltable('/ITENS/ITEM' passing c01_w.xml_itens_valor columns				/* ****TABELA REFERENCIA****  */
	CD_MATERIAL				numeric(30)		path	'CD_MATERIAL',			/*item_requisicao_material*/
	
	CD_MATERIAL_LIDO		numeric(30)		path	'CD_CHECKED_MATERIAL',		/*item_requisicao_material*/
	
	QT_BAIXAR				varchar(40)	path	'QT_SETTLEMENT',		/*item_requisicao_material*/
	NR_SEQ_LOTE_FORNEC		bigint		path	'NR_SUPPLIER_BATCH',		/*item_requisicao_material*/
	CD_MOTIVO_BAIXA			bigint		path	'CD_SETTLEMENT_REASON',	/*item_requisicao_material*/
	DT_ATENDIMENTO			varchar(40)	path	'DT_MATERIAL_PROCESSING',	/*item_requisicao_material*/
	CD_BARRAS				varchar(4000)	path	'CD_MATERIAL_BAR_CODE',	/*item_requisicao_material*/
	NM_USUARIO				varchar(15)	path	'NM_USER', 	/*item_requisicao_material*/
			
	CD_MAT_SUBST			numeric(30)		path	'CD_MAT_SUBSTITUTE');
	
c02_w	c02%rowtype;

BEGIN
nm_usuario_w := wheb_usuario_pck.get_nm_usuario;
cd_perfil_w	 := wheb_usuario_pck.get_cd_perfil;
/*'Atualiza o status da fila para Em processamento'*/

update	intpd_fila_transmissao
set	ie_status = 'R'
where	nr_sequencia = nr_sequencia_p;
/*'Realiza o commit para nao permite o status de processamento em casa de rollback por existir consistencia. Existe tratamento de exce? abaixo para colocar o status de erro em caso de falha'*/

commit;
/*'Inicio de controle de falha'*/

begin
/*'Busca os dados da regra do registro da fila que esta em processamento'*/

select	coalesce(b.ie_conversao,'I'),
	nr_seq_sistema,
	nr_seq_projeto_xml,
	nr_seq_regra_conv
into STRICT	ie_conversao_w,
	nr_seq_sistema_w,
	nr_seq_projeto_xml_w,
	nr_seq_regra_w
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia = nr_sequencia_p;

ie_sistema_externo_w	:=	nr_seq_sistema_w;

/*'Alimenta as informacoes iniciais de controle e consistencia de cada atributo do XML'*/

reg_integracao_w.nr_seq_fila_transmissao	:=	nr_sequencia_p;
reg_integracao_w.ie_envio_recebe		:=	'R';
reg_integracao_w.ie_sistema_externo		:=	ie_sistema_externo_w;
reg_integracao_w.ie_conversao		:=	ie_conversao_w;
reg_integracao_w.nr_seq_projeto_xml		:=	nr_seq_projeto_xml_w;
reg_integracao_w.nr_seq_regra_conversao	:=	nr_seq_regra_w;
reg_integracao_w.qt_reg_log			:=	0;
reg_integracao_w.intpd_log_receb.delete;
	
open c01;
loop
fetch c01 into	
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	
	select	max(cd_estabelecimento)
	into STRICT	cd_estabelecimento_w
	from	requisicao_material
	where	nr_requisicao = c01_w.nr_requisicao;
	
	CALL wheb_usuario_pck.set_cd_perfil(c01_w.cd_perfil);
	ie_atend_qt_maior_req_w := obter_vlr_parametro_perfil(109,c01_w.cd_perfil,4);
	
	/*'Alimenta as informacoes de controle e consistencia referente ao Elemento a ser processado no momento. E importante manter dentro do cursor e nao fora.'*/

	
	reg_integracao_w.nm_tabela		:=	'REQUISICAO_MATERIAL';
	reg_integracao_w.nm_elemento	:=	'REQUISICAO';
	reg_integracao_w.nr_seq_visao	:=	null;	
	
	/*'Consiste cada atributo do XML'*/
	
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_REQUISICAO', c01_w.nr_requisicao, 'N', item_requisicao_material_w.nr_requisicao) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; item_requisicao_material_w.nr_requisicao := _ora2pg_r.ds_valor_retorno_p;
	
	select	*
	into STRICT	requisicao_material_w
	from	requisicao_material
	where	nr_requisicao = item_requisicao_material_w.nr_requisicao;
	
	/*Verifica os lotes fornecedores no xml e realiza a consistencia de acordo com a regra Restri? de lote fornecedor*/

	open C02;
	loop
	fetch C02 into	
		c02_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		CALL wheb_usuario_pck.set_nm_usuario(coalesce(c02_w.nm_usuario, 'Tasy'));
		cd_mat_barras_w := coalesce(c02_w.cd_barras, coalesce(c02_w.cd_mat_subst, c02_w.cd_material));

		if (coalesce(ie_atend_qt_maior_req_w,'N') = 'N'  and (c01_w.cd_perfil IS NOT NULL AND c01_w.cd_perfil::text <> '')) then
			select	coalesce(sum(qt_material_requisitada),0)
			into STRICT	qt_mat_requititada_w
			from	item_requisicao_material
			where	nr_requisicao = item_requisicao_material_w.nr_requisicao
			and		cd_material = coalesce(c02_w.cd_material_lido, c02_w.cd_material)
			and (coalesce(nr_seq_lote_fornec::text, '') = '' or nr_seq_lote_fornec = c02_w.nr_seq_lote_fornec);
			
			if (coalesce(c02_w.cd_mat_subst,0) <> 0) and (qt_mat_requititada_w > 0) then
				select	qt_mat_requititada_w * coalesce(max(qt_material),0)
				into STRICT	qt_mat_requititada_w
				from	regra_mat_subst_atend
				where 	cd_material = c02_w.cd_material
				and 	cd_material_subst = c02_w.cd_mat_subst;
			end if;
			
			if (qt_mat_requititada_w > 0) and ((somente_numero_virg_char(replace(c02_w.qt_baixar, '.', ',')))::numeric  > qt_mat_requititada_w) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(176853, 'DS_MATERIAL=' || c02_w.cd_material || ';QT_MATERIAL=' || qt_mat_requititada_w);
			end if;
		end if;
		
		if (coalesce(c02_w.cd_mat_subst,0) <> 0) then
			select	coalesce(max(qt_material),0)
			into STRICT	qt_mat_requititada_w
			from	regra_mat_subst_atend
			where 	cd_material = c02_w.cd_material
			and 	cd_material_subst = c02_w.cd_mat_subst;

			if (qt_mat_requititada_w = 0) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(140024);
			end if;
		end if;
				
		select 	coalesce(max(c.cd_material),0)
		into STRICT 	cd_mat_req_w 	
		from	item_requisicao_material c
		where  	c.nr_requisicao = item_requisicao_material_w.nr_requisicao
		and (c.cd_material = Obter_Mat_Generico(c02_w.cd_material)
		or 		obter_se_generico_igual(c02_w.cd_material, cd_material) = 'S');
				
		if (c02_w.cd_barras IS NOT NULL AND c02_w.cd_barras::text <> '') then	
			SELECT * FROM converte_codigo_barras(cd_mat_barras_w, cd_estabelecimento_w, null, null, cd_material_w, qt_material_w, nr_seq_lote_fornec_w, nr_seq_loteagrup_w, cd_kit_mat_w, ds_validade_w, ds_material_w, cd_unid_med_w, nr_etiqueta_lp_w, ds_erro_w, 109, c01_w.nr_requisicao) INTO STRICT cd_material_w, qt_material_w, nr_seq_lote_fornec_w, nr_seq_loteagrup_w, cd_kit_mat_w, ds_validade_w, ds_material_w, cd_unid_med_w, nr_etiqueta_lp_w, ds_erro_w;
		
		elsif (obter_se_leitura_barras(cd_estabelecimento_w,cd_material_w,109,'T') = 'L') and (coalesce(c02_w.nr_seq_lote_fornec,0) = 0) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(281033);
		end if;
		
		if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
			CALL wheb_mensagem_pck.exibir_mensagem_abort(ds_erro_w);
		elsif (cd_mat_req_w = 0) then
			select	count(1)
			into STRICT	qt_existe_w
			from	item_requisicao_material
			where	nr_requisicao = c01_w.nr_requisicao
			and		cd_material = c02_w.cd_material;
		
			if (qt_existe_w = 0) then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(700341);
			end if;
		end if;
		end;
	end loop;
	close C02;
	
	open c02;
	loop
	fetch c02 into	
		c02_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		CALL wheb_usuario_pck.set_nm_usuario(nm_usuario_w);
		cd_mat_barras_w := coalesce(c02_w.cd_barras, coalesce(c02_w.cd_mat_subst, c02_w.cd_material));
		/*'Alimenta as informacoes de controle e consistencia referente ao Elemento a ser processado no momento. E importante manter dentro do cursor e nao fora.'*/

		reg_integracao_w.nm_tabela		:=	'ITEM_REQUISICAO_MATERIAL';
		reg_integracao_w.nm_elemento	:=	'ITEM';
		reg_integracao_w.nr_seq_visao	:=	null;		
		/*'Consiste cada atributo do XML'*/
		
		if (c02_w.cd_barras IS NOT NULL AND c02_w.cd_barras::text <> '') then
			SELECT * FROM converte_codigo_barras(cd_mat_barras_w, cd_estabelecimento_w, null, null, cd_material_w, qt_material_w, nr_seq_lote_fornec_w, nr_seq_loteagrup_w, cd_kit_mat_w, ds_validade_w, ds_material_w, cd_unid_med_w, nr_etiqueta_lp_w, ds_erro_w, null, null) INTO STRICT cd_material_w, qt_material_w, nr_seq_lote_fornec_w, nr_seq_loteagrup_w, cd_kit_mat_w, ds_validade_w, ds_material_w, cd_unid_med_w, nr_etiqueta_lp_w, ds_erro_w;
		end if;

		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_MATERIAL', c02_w.cd_material, 'S', item_requisicao_material_w.cd_material) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; item_requisicao_material_w.cd_material := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_MATERIAL_LIDO', c02_w.cd_material_lido, 'S', item_requisicao_material_w.cd_material_lido) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; item_requisicao_material_w.cd_material_lido := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'QT_BAIXAR', (somente_numero_virg_char(replace(c02_w.qt_baixar, '.', ',')))::numeric , 'N', item_requisicao_material_w.qt_material_atendida) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; item_requisicao_material_w.qt_material_atendida := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_SEQ_LOTE_FORNEC', coalesce(nr_seq_lote_fornec_w, c02_w.nr_seq_lote_fornec), 'N', item_requisicao_material_w.nr_seq_lote_fornec) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; item_requisicao_material_w.nr_seq_lote_fornec := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_MOTIVO_BAIXA', c02_w.cd_motivo_baixa, 'N', item_requisicao_material_w.cd_motivo_baixa) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; item_requisicao_material_w.cd_motivo_baixa := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'DT_ATENDIMENTO', c02_w.dt_atendimento, 'N', item_requisicao_material_w.dt_atendimento) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; item_requisicao_material_w.dt_atendimento := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_BARRAS', c02_w.cd_barras, 'N', item_requisicao_material_w.cd_barras) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; item_requisicao_material_w.cd_barras := _ora2pg_r.ds_valor_retorno_p;
		SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NM_USUARIO', c02_w.nm_usuario, 'N', item_requisicao_material_w.nm_usuario) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; item_requisicao_material_w.nm_usuario := _ora2pg_r.ds_valor_retorno_p;
		
		/*'Efetua a atualizacao caso nao possua consistencia '*/

		if (reg_integracao_w.qt_reg_log = 0) then
			begin

			if (item_requisicao_material_w.nr_seq_lote_fornec = 0) then
				item_requisicao_material_w.nr_seq_lote_fornec := null;
			end if;
			
			select 	coalesce(max(c.cd_material),0)
			into STRICT 	cd_mat_req_w 	
			from	item_requisicao_material c
			where  	c.nr_requisicao = item_requisicao_material_w.nr_requisicao
			and (c.cd_material = Obter_Mat_Generico(c02_w.cd_material)
			or 		obter_se_generico_igual(c02_w.cd_material, cd_material) = 'S');
				
			CALL baixar_item_requisicao(
				item_requisicao_material_w.nr_requisicao,
				coalesce(cd_mat_req_w,item_requisicao_material_w.cd_material),
				item_requisicao_material_w.cd_material_lido,
				item_requisicao_material_w.qt_material_atendida,
				item_requisicao_material_w.nr_seq_lote_fornec,
				item_requisicao_material_w.cd_motivo_baixa,
				requisicao_material_w.cd_operacao_estoque,
				'S',
				item_requisicao_material_w.dt_atendimento,
				item_requisicao_material_w.cd_barras,
				item_requisicao_material_w.nm_usuario);
									
			select	count(*)
			into STRICT	qt_existe_w
			from	item_requisicao_material
			where	nr_requisicao	= item_requisicao_material_w.nr_requisicao
			and	coalesce(obter_tipo_motivo_baixa_req(cd_motivo_baixa), 0) = 0;
			
			if (qt_existe_w =  0) then
			
				update	requisicao_material
				set	dt_baixa	= clock_timestamp()
				where	nr_requisicao	= item_requisicao_material_w.nr_requisicao;
				
			end if;
			
				update	intpd_fila_transmissao
				set	ie_status = 'S',
					nr_seq_documento = item_requisicao_material_w.nr_requisicao
				where	nr_sequencia = nr_sequencia_p;
				
			exception
			when others then
				reg_integracao_w.intpd_log_receb[reg_integracao_w.qt_reg_log].ds_log	:=	substr(sqlerrm,1,4000);
				reg_integracao_w.qt_reg_log						:=	reg_integracao_w.qt_reg_log + 1;
			end;
		end if;	
		end;
	end loop;
	close c02;
	end;
end loop;
close c01;
exception
when others then
	begin
	ds_erro_w	:=	substr(sqlerrm,1,4000);
	rollback;
	update	intpd_fila_transmissao
	set	ie_status = 'E',
		ds_log = ds_erro_w
	where	nr_sequencia = nr_sequencia_p;
	end;
end;

if (reg_integracao_w.qt_reg_log > 0) then
	begin
	/*'Em caso de qualquer consistencia o sistema efetua rollback, atualiza o status para Erro e registra todos os logs de consistencia'*/

	rollback;
	
	update	intpd_fila_transmissao
	set	ie_status = 'E',
		ds_log = ds_erro_w
	where	nr_sequencia = nr_sequencia_p;
	
	for i in 0..reg_integracao_w.qt_reg_log-1 loop
		intpd_gravar_log_recebimento(nr_sequencia_p,reg_integracao_w.intpd_log_receb[i].ds_log,'INTPDTASY');
	end loop;
	end;
end if;
	
commit;

CALL wheb_usuario_pck.set_nm_usuario(nm_usuario_w);
CALL wheb_usuario_pck.set_cd_perfil(cd_perfil_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intpd_recebe_material_med ( nr_sequencia_p bigint, xml_p xml) FROM PUBLIC;

