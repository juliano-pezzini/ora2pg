-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE kodip_pck.receive_pr_result ( reg_integracao_p INOUT gerar_int_padrao.reg_integracao_conv, nr_seq_episodio_p bigint, prresult_p xml) AS $body$
DECLARE

				
				
ds_conteudo_w		episodio_paciente_consist.ds_conteudo%type;
ds_erro_w		varchar(4000);

c01 CURSOR FOR
SELECT	msgid,
	msgtext,
	msglongtext,
	CASE WHEN sev='F' THEN  'E' WHEN sev='H' THEN  'I'  ELSE 'W' END  sev,
	category,
	prvaluelist
from	xmltable('/PrResult/ProofResult/PrMessages/PrMessage' passing prresult_p columns
		msgid 		varchar(15) path '@MsgId',
		msgtext 		varchar(255) path '@MsgText',
		msglongtext 	varchar(4000) path '@MsgLongText',
		sev 			varchar(15) path '@Sev',
		category		varchar(15) path '@Category',
		prvaluelist	xml path 'PrValueList');

c01_w          c01%rowtype;

c02 CURSOR FOR
SELECT	*
from	xmltable('/PrValueList/PrValue' passing c01_w.prvaluelist columns
		valuetype 		varchar(15) path '@ValueType',
		value 			varchar(15) path '@Value',
		valuetypetext 		varchar(255) path '@ValueTypeText');

c02_w          c02%rowtype;


BEGIN
open c01;
loop
fetch c01 into	
	c01_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	ds_conteudo_w := substr(c01_w.msglongtext || chr(13) || chr(10),1,4000);
	
	open c02;
	loop
	fetch c02 into	
		c02_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		ds_conteudo_w := substr(ds_conteudo_w || chr(13) || chr(10) || c02_w.valuetypetext || ': ' || c02_w.value,1,4000);
	end loop;
	close c02;

	CALL kodip_pck.generate_case_consist(nr_seq_episodio_p, c01_w.msgtext, ds_conteudo_w, c01_w.sev, 'KODIP-RECEIVE');
	commit;
	exception
	when others then
		begin
		ds_erro_w	:=	substr('Error reading c01-PrResult/ProofResult/PrMessages/PrMessage: ' || sqlerrm || chr(13) || chr(10) ||
						dbms_utility.format_error_backtrace,1, 2000);
		CALL CALL kodip_pck.incluir_log(reg_integracao_p, ds_erro_w, 'KODIP-RECEIVE', 'W');
		rollback;
		end;
	end;
end loop;
close c01;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE kodip_pck.receive_pr_result ( reg_integracao_p INOUT gerar_int_padrao.reg_integracao_conv, nr_seq_episodio_p bigint, prresult_p xml) FROM PUBLIC;