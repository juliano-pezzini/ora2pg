-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_informacao_gqa ( nr_atendimento_p bigint, nm_tabela_p text, qt_chave_p bigint, nm_usuario_p text, ie_html5_p text default 'N') AS $body$
DECLARE


nr_regras_atendidas_w  varchar(2000);
ie_gera_prot_assistencial   boolean := False;
nr_seq_mentor_w		bigint;


BEGIN

if (upper(nm_tabela_p)	= 'DIAGNOSTICO_DOENCA') then
	
	if ( ie_html5_p = 'N' ) then -- Ja e realizado no objeto liberar_informacao. Duplicidade de geracaoo.
	
		SELECT * FROM GQA_LIBERACAO_DIAGNOSTICO(qt_chave_p, nm_usuario_p, nr_seq_mentor_w, nr_regras_atendidas_w) INTO STRICT nr_seq_mentor_w, nr_regras_atendidas_w;
		ie_gera_prot_assistencial := True;
			
		CALL Gerar_tof_meta_atend(nr_atendimento_p , nm_usuario_p);
	
	End if;

elsif (upper(nm_tabela_p)	= 'QUA_EVENTO_PACIENTE') then
		
	nr_regras_atendidas_w := GQA_LIBERACAO_QUA_EVENTO(qt_chave_p, nm_usuario_p, nr_regras_atendidas_w, nr_atendimento_p);
    ie_gera_prot_assistencial := True;
		
	CALL Gerar_tof_meta_atend(nr_atendimento_p , nm_usuario_p);
	
elsif (upper(nm_tabela_p)	= 'CUR_CURATIVO') then
		
	nr_regras_atendidas_w := GQA_LIBERACAO_CURATIVO(nr_atendimento_p, qt_chave_p, nm_usuario_p, nr_regras_atendidas_w);
    ie_gera_prot_assistencial := True;
	
	CALL Gerar_tof_meta_atend(nr_atendimento_p , nm_usuario_p);

elsif (upper(nm_tabela_p) = 'PROTOCOLO_INT_PAC_EVENTO') then

  nr_regras_atendidas_w := GQA_LIBERACAO_PROT_INT_EVENTO(qt_chave_p, nm_usuario_p, nr_atendimento_p, nr_regras_atendidas_w);
	
else

	nr_regras_atendidas_w := GQA_Liberacao_Escala(nr_atendimento_p, qt_chave_p, nm_usuario_p, nm_tabela_p, nr_regras_atendidas_w, null);
    ie_gera_prot_assistencial := True;
	
	CALL Gerar_tof_meta_atend(nr_atendimento_p , nm_usuario_p);
end if;	
		
commit;	


if ie_gera_prot_assistencial then
    CALL gera_protocolo_assistencial(nr_atendimento_p, nm_usuario_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_informacao_gqa ( nr_atendimento_p bigint, nm_tabela_p text, qt_chave_p bigint, nm_usuario_p text, ie_html5_p text default 'N') FROM PUBLIC;

