-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE intpd_recebe_portador ( nr_sequencia_p bigint, xml_p xml) AS $body$
DECLARE


_ora2pg_r RECORD;
ie_conversao_w				intpd_eventos_sistema.ie_conversao%type;
nr_seq_sistema_w			intpd_eventos_sistema.nr_seq_sistema%type;
nr_seq_projeto_xml_w		intpd_eventos_sistema.nr_seq_projeto_xml%type;
nr_seq_regra_w				conversao_meio_externo.nr_seq_regra%type;
ie_sistema_externo_w		varchar(15);
reg_integracao_w			gerar_int_padrao.reg_integracao_conv;
portador_w					portador%rowtype;
ds_erro_w					varchar(4000);
qt_reg_w					bigint;

c01 CURSOR FOR
SELECT	*
from	xmltable('/STRUCTURE/BEARER' passing xml_p columns
		cd_tipo_portador				integer		path	'CD_BEARER_TYPE',
		ds_portador						varchar(50)	path	'DS_BEARER',
		nm_usuario						varchar(15)	path	'NM_USER',
		ie_situacao						varchar(1)		path	'IE_STATUS',
		ie_baixa_titulo_receber			varchar(1)		path	'IE_RECEIVABLE_DOC_SETTLEMENT');

c01_w	c01%rowtype;

BEGIN

/*'Atualiza o status da fila para Em processamento'*/

update	intpd_fila_transmissao
set		ie_status 		= 'R'
where	nr_sequencia 	= nr_sequencia_p;

/*'Realiza o commit para não permite o status de processamento em casa de rollback por existir consistência. Existe tratamento de exceção abaixo para colocar o status de erro em caso de falha'*/

commit;

begin

select	coalesce(max(b.ie_conversao),'I'),
		max(nr_seq_sistema),
		max(nr_seq_projeto_xml),
		max(nr_seq_regra_conv)
into STRICT	ie_conversao_w,
		nr_seq_sistema_w,
		nr_seq_projeto_xml_w,
		nr_seq_regra_w
from	intpd_fila_transmissao a,
		intpd_eventos_sistema b
where	a.nr_seq_evento_sistema = b.nr_sequencia
and		a.nr_sequencia 			= nr_sequencia_p;

ie_sistema_externo_w	:=	nr_seq_sistema_w;

/*'Alimenta as informações iniciais de controle e consistência de cada atributo do XML'*/

reg_integracao_w.nr_seq_fila_transmissao	:=	nr_sequencia_p;
reg_integracao_w.ie_envio_recebe			:=	'R';
reg_integracao_w.ie_sistema_externo			:=	ie_sistema_externo_w;
reg_integracao_w.ie_conversao				:=	ie_conversao_w;
reg_integracao_w.nr_seq_projeto_xml			:=	nr_seq_projeto_xml_w;
reg_integracao_w.nr_seq_regra_conversao		:=	nr_seq_regra_w;
reg_integracao_w.intpd_log_receb.delete;
reg_integracao_w.qt_reg_log					:=	0;

open C01;
loop
fetch C01 into
	c01_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	reg_integracao_w.nm_tabela			:=	'PORTADOR';
	reg_integracao_w.nm_elemento		:=	'BEARER';
	reg_integracao_w.nr_seq_visao		:=	'';

	if ( upper(c01_w.ie_situacao) not in ('I','A')) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(767003,'ie_situacao='||c01_w.ie_situacao);
	else
		c01_w.ie_situacao := upper(c01_w.ie_situacao);
	end if;

	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'CD_TIPO_PORTADOR', c01_w.cd_tipo_portador, 'S', portador_w.cd_tipo_portador) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; portador_w.cd_tipo_portador := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'DS_PORTADOR', c01_w.ds_portador, 'N', portador_w.ds_portador) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; portador_w.ds_portador := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NM_USUARIO', c01_w.nm_usuario, 'N', portador_w.nm_usuario) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; portador_w.nm_usuario := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_SITUACAO', c01_w.ie_situacao, 'N', portador_w.ie_situacao) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; portador_w.ie_situacao := _ora2pg_r.ds_valor_retorno_p;
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'IE_BAIXA_TITULO_RECEBER', c01_w.ie_baixa_titulo_receber, 'S', portador_w.ie_baixa_titulo_receber) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; portador_w.ie_baixa_titulo_receber := _ora2pg_r.ds_valor_retorno_p;

	select	count(*)
	into STRICT	qt_reg_w
	from	portador
	where	upper(ds_portador)	= upper(portador_w.ds_portador)
	and		cd_tipo_portador	= portador_w.cd_tipo_portador;

	if (qt_reg_w > 0) then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(770484,'ds_portador='||portador_w.ds_portador);
	end if;

	if (reg_integracao_w.qt_reg_log = 0) then
		begin
		select	coalesce(max(cd_portador),0) +  1
		into STRICT	portador_w.cd_portador
		from	portador;

		portador_w.dt_atualizacao := clock_timestamp();

		insert into portador values (portador_w.*);
		end;
	end if;

	end;
end loop;
close C01;
exception
when others then
	begin
	/*'Em caso de qualquer falha o sistema captura a mensagem de erro, efetua o rollback, atualiza o status para Erro e registra a falha ocorrida'*/

	ds_erro_w	:=	substr(sqlerrm,1,4000);
	rollback;
	update	intpd_fila_transmissao
	set		ie_status 		= 'E',
			ds_log 			= ds_erro_w
	where	nr_sequencia 	= nr_sequencia_p;
	end;
end;

if (reg_integracao_w.qt_reg_log > 0) then
	begin
	/*'Em caso de qualquer consistência o sistema efetua rollback, atualiza o status para Erro e registra todos os logs de consistência'*/

	rollback;

	update	intpd_fila_transmissao
	set		ie_status 		= 'E',
			ds_log 			= ds_erro_w
	where	nr_sequencia 	= nr_sequencia_p;

	for i in 0..reg_integracao_w.qt_reg_log-1 loop
		intpd_gravar_log_recebimento(nr_sequencia_p,reg_integracao_w.intpd_log_receb[i].ds_log,'INTPDTASY');
	end loop;
	end;
end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intpd_recebe_portador ( nr_sequencia_p bigint, xml_p xml) FROM PUBLIC;
