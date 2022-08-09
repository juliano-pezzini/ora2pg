-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE intpd_dispensar_lote ( nr_sequencia_p bigint, xml_p xml) AS $body$
DECLARE


_ora2pg_r RECORD;
ap_lote_w			ap_lote%rowtype;
reg_integracao_w		gerar_int_padrao.reg_integracao_conv;
nr_seq_regra_w			conversao_meio_externo.nr_seq_regra%type;
nr_seq_projeto_xml_w		intpd_eventos_sistema.nr_seq_projeto_xml%type;
nr_seq_sistema_w		intpd_eventos_sistema.nr_seq_sistema%type;
ie_sistema_externo_w		varchar(15);
ds_erro_w			varchar(4000);
ie_conversao_w			intpd_eventos_sistema.ie_conversao%type;
cd_estabelecimento_w		prescr_medica.cd_estabelecimento%type;

c01 CURSOR FOR
SELECT	*
from	xmltable('/STRUCTURE/BATCH' passing xml_p columns
	IE_ACAO				varchar(1)	path	'IE_ACTION',
	NR_SEQUENCIA			bigint	path	'NR_SEQUENCE');

c01_w	c01%rowtype;

BEGIN

update	intpd_fila_transmissao
set	ie_status = 'R'
where	nr_sequencia = nr_sequencia_p;
commit;

begin

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

reg_integracao_w.nr_seq_fila_transmissao	:= nr_sequencia_p;
reg_integracao_w.ie_envio_recebe		:= 'R';
reg_integracao_w.ie_sistema_externo		:= ie_sistema_externo_w;
reg_integracao_w.ie_conversao		:= ie_conversao_w;
reg_integracao_w.nr_seq_projeto_xml		:= nr_seq_projeto_xml_w;
reg_integracao_w.nr_seq_regra_conversao	:= nr_seq_regra_w;
reg_integracao_w.qt_reg_log			:= 0;
reg_integracao_w.intpd_log_receb.delete;


open c01;
loop
fetch c01 into	
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	reg_integracao_w.nm_tabela	:=	'AP_LOTE';
	reg_integracao_w.nm_elemento	:=	'BATCH';
	reg_integracao_w.nr_seq_visao	:=	null;	
	
	/*'Consiste cada atributo do XML'*/
	
	SELECT * FROM intpd_processar_atributo(reg_integracao_w, 'NR_SEQUENCIA', c01_w.nr_sequencia, 'N', ap_lote_w.nr_sequencia) INTO STRICT _ora2pg_r;
 reg_integracao_w := _ora2pg_r.reg_integracao_p; ap_lote_w.nr_sequencia := _ora2pg_r.ds_valor_retorno_p;
	
	select	coalesce(max(a.cd_estabelecimento),0),
		coalesce(max(b.ie_status_lote),'G')
	into STRICT	cd_estabelecimento_w,
		ap_lote_w.ie_status_lote
	from	prescr_medica a,
		ap_lote b
	where 	a.nr_prescricao = b.nr_prescricao
	and 	b.nr_sequencia  = ap_lote_w.nr_sequencia;
	
	if (ap_lote_w.ie_status_lote = 'D') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(264581,'NR_LOTE_P=' || ap_lote_w.nr_sequencia);
	end if;
	
	CALL atualiza_status_lote(ap_lote_w.nr_sequencia,cd_estabelecimento_w,0,'WMS','D');
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

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE intpd_dispensar_lote ( nr_sequencia_p bigint, xml_p xml) FROM PUBLIC;
