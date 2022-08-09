-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_conta_proc_consulta ( nr_seq_conta_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, qt_procedimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_procedimento_p timestamp, dt_hora_inicio_p timestamp, dt_hora_fim_p timestamp) AS $body$
DECLARE
				
				
nr_seq_conta_proc_w		bigint;		
dt_atendimento_referencia_w	timestamp;

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_conta_proc
	where	nr_seq_conta	= nr_seq_conta_p;
		

BEGIN
			
select	nextval('pls_conta_proc_seq')
into STRICT	nr_seq_conta_proc_w		
;

/*  ALTERADO DT_EMISSAO PARA DT_ATENDIMENTO_REFERENCIA */

select	dt_atendimento_referencia
into STRICT	dt_atendimento_referencia_w
from	pls_conta
where	nr_sequencia = nr_seq_conta_p;

begin
insert into pls_conta_proc(nr_sequencia, qt_procedimento_imp, ie_origem_proced,
	 nr_seq_conta, dt_atualizacao, nm_usuario,
	 ie_situacao, ie_status, cd_procedimento,
	 tx_item, vl_unitario, vl_liberado,
	 ie_tipo_despesa, dt_procedimento, vl_unitario_imp,
	 vl_procedimento_imp, qt_procedimento, ie_valor_informado,
	 dt_inicio_proc,dt_fim_proc)
values (nr_seq_conta_proc_w, qt_procedimento_p, ie_origem_proced_p,
	 nr_seq_conta_p, clock_timestamp(), nm_usuario_p,
	 'D', 'U', cd_procedimento_p,
	 100, 0, 0,
	 1, coalesce(dt_procedimento_p,dt_atendimento_referencia_w), 0, 
	 0, qt_procedimento_p, 'N',
	 dt_hora_inicio_p, dt_hora_fim_p);
	 
CALL pls_cta_proc_mat_regra_pck.cria_registro_regra_proc(nr_seq_conta_proc_w, nm_usuario_p);
CALL pls_cta_proc_mat_regra_pck.gera_seq_tiss_proc(nr_seq_conta_proc_w, null, null, nr_seq_conta_p, nm_usuario_p);

 exception
 when others then
/*(-20011,nr_seq_conta_p||' - '||
				cd_procedimento_p||' - '||
				ie_origem_proced_p||' - '||
				qt_procedimento_p||' - '||
				nm_usuario_p||' - '||
				cd_estabelecimento_p||' - '||
				nr_seq_conta_proc_w||' - '||'#@#@');	*/

--(-20011,'Um erro ocorreu ao inserir o(s) procedimento(s). Operação abortada.'||'#@#@');	
CALL wheb_mensagem_pck.exibir_mensagem_abort(192634);			
end;
/*Poderá gerar mais procedimento.*/

CALL pls_lanc_auto_conta_medica(nr_seq_conta_p, nr_seq_conta_proc_w, null, nm_usuario_p, cd_estabelecimento_p,'N');
open C01;
loop
fetch C01 into	
	nr_seq_conta_proc_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	CALL pls_atualiza_valor_proc(nr_seq_conta_proc_w,'N', nm_usuario_p,'S',null,null);
	end;
end loop;
close C01;

commit;
			
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_conta_proc_consulta ( nr_seq_conta_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint, qt_procedimento_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, dt_procedimento_p timestamp, dt_hora_inicio_p timestamp, dt_hora_fim_p timestamp) FROM PUBLIC;
