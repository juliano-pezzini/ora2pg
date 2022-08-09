-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE intpd_receber_procedimento ( nr_sequencia_p bigint, xml_p xml) AS $body$
DECLARE


_ora2pg_r RECORD;
ie_conversao_w			intpd_eventos_sistema.ie_conversao%type;
nr_seq_projeto_xml_w		intpd_eventos_sistema.nr_seq_projeto_xml%type;
nr_seq_sistema_w			intpd_eventos_sistema.nr_seq_sistema%type;
ie_sistema_externo_w		varchar(15);
reg_integracao_w			gerar_int_padrao.reg_integracao_conv;
nr_seq_regra_w			conversao_meio_externo.nr_seq_regra%type;
ds_erro_w			varchar(4000);
ie_erro_w				varchar(1) := 'N';
ie_exception_w			varchar(1) := 'N';
i				integer;
qt_registros_w			bigint;
procedimento_w			procedimento%rowtype;
ie_ajustar_ins_upd_w		intpd_eventos_sistema.ie_ajustar_ins_upd%type;
ie_ajustar_upd_ins_w		intpd_eventos_sistema.ie_ajustar_upd_ins%type;

c01 CURSOR FOR
SELECT	*
from	xmltable('/STRUCTURE/PROCEDURE' passing xml_p columns
	ie_action				varchar(40)		path		'IE_ACTION',
	cd_grupo_proc			bigint		path		'CD_PROC_GROUP',
	cd_tipo_procedimento		smallint			path		'CD_PROC_TYPE',
	cd_procedimento			bigint		path		'CD_PROCEDURE',
	cd_intervalo			varchar(7)		path		'CD_INTERVAL',
	ds_procedimento			varchar(255)		path		'DS_PROCEDURE',
	ie_alta_complexidade		varchar(1)		path		'IE_HIGH_COMPLEXITY',
	ie_ativ_prof_bpa			varchar(1)		path		'IE_ACTIVITY_PROF_BPA',
	ie_classif_custo			varchar(1)		path		'IE_COST_CLASSIFICATION',
	ie_classificacao			varchar(1)		path		'IE_CLASSIFICATION',
	ie_exige_autor_sus 			varchar(1)		path		'IE_NEEDS_SUS_AUTHORIZATION',
	ie_ignora_origem			varchar(1)		path		'IE_IGNORES_SOURCE',
	ie_localizador			varchar(1)		path		'IE_LOCATOR',
	ie_origem_proced			bigint		path		'IE_SOURCE_PROC',
	ie_exige_lado			varchar(1)		path		'IE_REQUIRES_SIDE',
	ie_situacao			varchar(1)		path		'IE_STATUS',
	qt_exec_barra			smallint			path		'QT_BAR_EXECUTION',
	qt_hora_baixar_prescr		integer			path		'QT_TIME_PRESCRIPTION_EXEC',
	nm_usuario			varchar(15)		path		'NM_USER',
	dt_atualizacao			varchar(14)		path		'DT_UPDATE',
	cd_sistema_ant			varchar(80)		path		'NR_EXTERNAL_DOCUMENT');

c01_w	c01%rowtype;


BEGIN

/*Atualiza o status da fila para Em processamento*/

update	intpd_fila_transmissao
set	ie_status = 'R'
where	nr_sequencia = nr_sequencia_p;

commit;

begin

select	coalesce(b.ie_conversao,'I'),
	nr_seq_sistema,
	nr_seq_projeto_xml,
	nr_seq_regra_conv,
	ie_ajustar_ins_upd,
	ie_ajustar_upd_ins
into STRICT	ie_conversao_w,
	nr_seq_sistema_w,
	nr_seq_projeto_xml_w,
	nr_seq_regra_w,
	ie_ajustar_ins_upd_w,
	ie_ajustar_upd_ins_w
from	intpd_fila_transmissao a,
	intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and	a.nr_sequencia = nr_sequencia_p;

ie_sistema_externo_w			:=	nr_seq_sistema_w;
reg_integracao_w.nr_seq_fila_transmissao	:=	nr_sequencia_p;
reg_integracao_w.ie_envio_recebe		:=	'R';
reg_integracao_w.ie_sistema_externo		:=	ie_sistema_externo_w;
reg_integracao_w.ie_conversao		:=	ie_conversao_w;
reg_integracao_w.nr_seq_projeto_xml		:=	nr_seq_projeto_xml_w;
reg_integracao_w.nr_seq_regra_conversao	:=	nr_seq_regra_w;
reg_integracao_w.intpd_log_receb.delete;
reg_integracao_w.qt_reg_log			:=	0;

open c01;
loop
fetch c01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	begin
	ie_erro_w			:= 	'N';
	reg_integracao_w.nm_tabela	:=	'PROCEDIMENTO';
	reg_integracao_w.nm_elemento	:=	'PROCEDURE';
	reg_integracao_w.nr_seq_visao	:=	95763; /*HTML5 - Procedimentos - México*/
	if (ie_conversao_w = 'I') and (nr_seq_regra_w > 0) then
		procedimento_w.cd_procedimento := bkf_obter_conv_interna(null, 'PROCEDIMENTO', 'CD_PROCEDIMENTO', c01_w.cd_sistema_ant, null, nr_seq_regra_w);
	else
		if (coalesce(procedimento_w.cd_procedimento,0) = 0) and (c01_w.cd_sistema_ant IS NOT NULL AND c01_w.cd_sistema_ant::text <> '') then

			procedimento_w.cd_sistema_ant := c01_w.cd_sistema_ant;

			select	max(cd_procedimento)
			into STRICT	procedimento_w.cd_procedimento
			from	procedimento
			where	cd_sistema_ant = procedimento_w.cd_sistema_ant;

		else
			procedimento_w.cd_procedimento := c01_w.cd_procedimento;
		end if;
	end if;

	if (coalesce(upper(c01_w.ie_action),'INSERT') <> 'DELETE') then /*INSERT ou UPDATE*/
		begin

		select 	count(*)
		into STRICT	qt_registros_w
		from 	procedimento
		where 	cd_procedimento = procedimento_w.cd_procedimento
		and	ie_origem_proced = c01_w.ie_origem_proced;


		if (coalesce(upper(c01_w.ie_action),'INSERT') = 'UPDATE') then
			begin

			if (ie_ajustar_upd_ins_w = 'N') and /*Quando o sistema externo manda um UPDATE mas o registro não existe no Tasy. Neste caso se o campo IE_AJUSTAR_UPD_INS_W está para N, retornaremos mensagem de erro para o sistema externo.*/
				(qt_registros_w = 0) then
				intpd_gravar_log_recebimento(nr_sequencia_p,wheb_mensagem_pck.get_texto(1048545),'INTPDTASY','0013');
				ie_erro_w := 'S';
				/*Não há no sistema procedimento com este código, portanto não é possível realizar a alteração. Favor enviar uma operação de "Insert" caso queira adicionar este registro no Tasy.*/

			elsif (qt_registros_w = 0) then
				c01_w.ie_action := 'INSERT';
			end if;
			end;

		elsif (coalesce(upper(c01_w.ie_action),'INSERT') = 'INSERT') then
			begin
			if (ie_ajustar_ins_upd_w = 'N') and /*Quando o sistema externo manda um INSERT mas o registro já existe no Tasy. Neste caso se o campo IE_AJUSTAR_INS_UPD está para N, retornaremos mensagem de erro para o sistema externo.*/
				(qt_registros_w > 0) then
				intpd_gravar_log_recebimento(nr_sequencia_p,wheb_mensagem_pck.get_texto(1048550),'INTPDTASY','0014');
				ie_erro_w := 'S';
				/*Já há procedimento cadastrado com esses dados, portanto não é possível realizar a inserção. Favor enviar uma operação de "Update" caso queira atualizar este registro no Tasy.*/

			end if;
			end;
		end if;

		if (ie_erro_w = 'N') then
			begin
			begin
			/*'Busca o registro atual do Tasy pela PK'
			Esse tratamento foi necessário porque quando é update, o sistema externo só envia as informações alteradas e o restante dos campos eles mandam vazio. Então temos que buscar a informação que já está gravada na tabela.*/
			select	*
			into STRICT	procedimento_w
			from	procedimento
			where 	cd_procedimento = procedimento_w.cd_procedimento
			and	ie_origem_proced = c01_w.ie_origem_proced;
			exception
			when others then
				null;
			end;

			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_GRUPO_PROC', c01_w.cd_grupo_proc, 'S', procedimento_w.cd_grupo_proc) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; procedimento_w.cd_grupo_proc := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_TIPO_PROCEDIMENTO', c01_w.cd_tipo_procedimento, 'N', procedimento_w.cd_tipo_procedimento) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; procedimento_w.cd_tipo_procedimento := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_INTERVALO', c01_w.cd_intervalo, 'N', procedimento_w.cd_intervalo) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; procedimento_w.cd_intervalo := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'DS_PROCEDIMENTO', c01_w.ds_procedimento, 'N', procedimento_w.ds_procedimento) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; procedimento_w.ds_procedimento := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_ALTA_COMPLEXIDADE', c01_w.ie_alta_complexidade, 'N', procedimento_w.ie_alta_complexidade) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; procedimento_w.ie_alta_complexidade := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_ATIV_PROF_BPA', c01_w.ie_ativ_prof_bpa, 'N', procedimento_w.ie_ativ_prof_bpa) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; procedimento_w.ie_ativ_prof_bpa := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_CLASSIF_CUSTO', c01_w.ie_classif_custo, 'N', procedimento_w.ie_classif_custo) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; procedimento_w.ie_classif_custo := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_CLASSIFICACAO', c01_w.ie_classificacao, 'N', procedimento_w.ie_classificacao) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; procedimento_w.ie_classificacao := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_EXIGE_AUTOR_SUS', c01_w.ie_exige_autor_sus, 'N', procedimento_w.ie_exige_autor_sus) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; procedimento_w.ie_exige_autor_sus := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_IGNORA_ORIGEM', c01_w.ie_ignora_origem, 'N', procedimento_w.ie_ignora_origem) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; procedimento_w.ie_ignora_origem := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_LOCALIZADOR', c01_w.ie_localizador, 'N', procedimento_w.ie_localizador) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; procedimento_w.ie_localizador := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_ORIGEM_PROCED', c01_w.ie_origem_proced, 'N', procedimento_w.ie_origem_proced) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; procedimento_w.ie_origem_proced := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_EXIGE_LADO', c01_w.ie_exige_lado, 'N', procedimento_w.ie_exige_lado) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; procedimento_w.ie_exige_lado := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'QT_EXEC_BARRA', c01_w.qt_exec_barra, 'N', procedimento_w.qt_exec_barra) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; procedimento_w.qt_exec_barra := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'QT_HORA_BAIXAR_PRESCR', c01_w.qt_hora_baixar_prescr, 'N', procedimento_w.qt_hora_baixar_prescr) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; procedimento_w.qt_hora_baixar_prescr := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NM_USUARIO', c01_w.nm_usuario, 'N', procedimento_w.nm_usuario) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; procedimento_w.nm_usuario := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'DT_ATUALIZACAO', c01_w.dt_atualizacao, 'N', procedimento_w.dt_atualizacao) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; procedimento_w.dt_atualizacao := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_SISTEMA_ANT', c01_w.cd_sistema_ant, 'N', procedimento_w.cd_sistema_ant) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; procedimento_w.cd_sistema_ant := _ora2pg_r.ds_valor_retorno_p;
			SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_SITUACAO', c01_w.ie_situacao, 'N', procedimento_w.ie_situacao) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; procedimento_w.ie_situacao := _ora2pg_r.ds_valor_retorno_p;

			if (reg_integracao_w.qt_reg_log = 0) then
				begin

				if (procedimento_w.cd_tipo_procedimento = 142) and /*Quando o tipo do procedimento é "Pacote"*/
					(coalesce(upper(c01_w.ie_action),'INSERT') = 'INSERT') then /*E quando é INSERT, sempre cria como inativo. Isso porque o procedimento ainda não está vinculado com pacote e com convenio. Na integração de pacote (intpd_receber_pacotes)  ele faz a ativação do procedimento.*/
					procedimento_w.ie_situacao := 'I';
				elsif (procedimento_w.cd_tipo_procedimento = 142) and /*Quando o tipo de procedimento é "Pacote"*/
					(coalesce(upper(c01_w.ie_action),'INSERT') = 'UPDATE') then /*Quando é UPDATE o sistema verifica:  Se recebemos INATIVO, coloca o procedimento para inativo. Se recebemos ATIVO, colocamos o procedimento para ativo somente se tem um pacote deste procedimento. Isso é para nao utilizar esse procedimento se ele ainda nao é pacote.*/
					begin
					if (procedimento_w.ie_situacao = 'A') then /*Se recebemos ATIVO, faremos a verificação se tem pacote. Ele ativa somente se tem um pacote.*/
						select	count(*)
						into STRICT	qt_registros_w
						from	pacote
						where	cd_proced_pacote = procedimento_w.cd_procedimento
						and	ie_situacao = 'A';

						if (qt_registros_w > 0) then
							procedimento_w.ie_situacao := 'A';
						else
							procedimento_w.ie_situacao := 'I';
						end if;
					else
						procedimento_w.ie_situacao := 'I';
					end if;
					end;
				end if;

				select 	max(cd_procedimento)
				into STRICT	procedimento_w.cd_procedimento
				from 	procedimento
				where 	cd_procedimento = procedimento_w.cd_procedimento
				and	ie_origem_proced = procedimento_w.ie_origem_proced;

				if (coalesce(procedimento_w.cd_procedimento,0) > 0) then
					update	procedimento
					set	row = procedimento_w
					where 	cd_procedimento = procedimento_w.cd_procedimento
					and	ie_origem_proced = procedimento_w.ie_origem_proced;
				else
					select 	nextval('procedimento_seq')
					into STRICT	procedimento_w.cd_procedimento
					;

					insert into procedimento values (procedimento_w.*);

					if (nr_seq_regra_w > 0) then
						CALL gerar_conv_meio_externo(null, 'PROCEDIMENTO', 'CD_PROCEDIMENTO', procedimento_w.cd_procedimento, procedimento_w.cd_sistema_ant, null, nr_seq_regra_w, 'A', procedimento_w.nm_usuario);
					end if;
				end if;
				end;
			end if;
			end;
		end if;
		end;
	elsif (coalesce(upper(c01_w.ie_action),'INSERT') = 'DELETE') then /*DELETE*/
		begin
		select 	max(cd_procedimento)
		into STRICT	procedimento_w.cd_procedimento
		from 	procedimento
		where 	cd_procedimento = procedimento_w.cd_procedimento
		and	ie_origem_proced = c01_w.ie_origem_proced;

		if (coalesce(procedimento_w.cd_procedimento,0) > 0) then
			delete	FROM procedimento
			where 	cd_procedimento = procedimento_w.cd_procedimento
			and	ie_origem_proced = c01_w.ie_origem_proced;
		else
			/*Código do procedimento inválido ou inexistente no Tasy para alteração ou exclusão do registro.*/

			intpd_gravar_log_recebimento(nr_sequencia_p,wheb_mensagem_pck.get_texto(1022440),'INTPDTASY','0004');
			ie_erro_w := 'S';
		end if;
		end;
	end if;
	end;
end loop;
close c01;

exception
when others then
	begin
	ds_erro_w := substr(dbms_utility.format_error_backtrace || chr(13) || chr(10) || sqlerrm,1,4000);
	rollback;

	update	intpd_fila_transmissao
	set	ie_status 	 	= 'E',
		cd_default_message 	= CASE WHEN ds_erro_w = NULL THEN null  ELSE '0005' END ,
		ds_log 		= ds_erro_w,
		nr_doc_externo	= c01_w.cd_sistema_ant
	where	nr_sequencia 	= nr_sequencia_p;

	ie_exception_w := 'S';

	end;
end;

if (ie_exception_w = 'N') then

	if	((reg_integracao_w.qt_reg_log > 0) or (coalesce(ie_erro_w,'N') = 'S')) then
		begin
		rollback;

		update	intpd_fila_transmissao
		set	ie_status		= 'E',
			cd_default_message 	= CASE WHEN ds_erro_w = NULL THEN null  ELSE '0005' END ,
			ds_log 		= ds_erro_w,
			nr_doc_externo	= c01_w.cd_sistema_ant
		where	nr_sequencia 	= nr_sequencia_p;

		for i in 0..reg_integracao_w.qt_reg_log-1 loop
			intpd_gravar_log_recebimento(nr_sequencia_p,reg_integracao_w.intpd_log_receb[i].ds_log,'INTPDTASY',reg_integracao_w.intpd_log_receb[i].cd_default_message);
		end loop;
		end;
	else
		update	intpd_fila_transmissao
		set	ie_status		= 'S',
			cd_default_message	= '0000',
			nr_seq_documento	= procedimento_w.cd_procedimento,
			nr_doc_externo	= c01_w.cd_sistema_ant
		where	nr_sequencia	= nr_sequencia_p;
	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intpd_receber_procedimento ( nr_sequencia_p bigint, xml_p xml) FROM PUBLIC;
