-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE consultar_eleg_taxas_remun ( nr_seq_dados_clinicos_p DADOS_CLINICOS_MOD_REMUN.nr_sequencia%type default null, NM_USUARIO_P USUARIO.NM_USUARIO%TYPE DEFAULT 'job') AS $body$
DECLARE


c_sucesso constant  varchar(15) := 'sucesso';
SUBTYPE one_char IS varchar(1);
SUBTYPE sixteen_char IS varchar(16);
SUBTYPE eighteen_char IS varchar(18);
data_w                  text;
c_nr_integration_code   CONSTANT integer := 1172;
char_s_c                CONSTANT one_char := 'S';
codigoprestador_c       CONSTANT eighteen_char := '"codigoPrestador":';
codigocliente_c         CONSTANT sixteen_char := '"codigoCliente":';
one_number_c            CONSTANT integer := 1;
json_open_brace_c       CONSTANT one_char := '{';
json_closed_brace_c     CONSTANT one_char := '}';
json_comma_c            CONSTANT one_char := ',';
quotation_mark_c        CONSTANT one_char := '"';
C_ATIVO			CONSTANT varchar(10) := 'ATIVO';

NR_SEQ_DADO_CLINICO_W	DADOS_CLINICOS_MOD_REMUN.NR_SEQUENCIA%TYPE;

C_PEND CURSOR FOR
	SELECT	A.NR_SEQUENCIA NR_SEQUENCIA_AUTOR,
		COALESCE(T.CD_USUARIO_CONVENIO,M.CD_USUARIO_CONVENIO) NR_CARTEIRA,
		SUBSTR(OBTER_CODIGO_INTERNO_CONV(A.CD_ESTABELECIMENTO, A.CD_CONVENIO),1,15) CD_PRESTADOR,
		A.NR_SEQ_DADOS_MOD_REMUN
	FROM can_loco_regional r, dados_clinicos_mod_remun m, autorizacao_convenio a
LEFT OUTER JOIN autorizacao_convenio_tiss t ON (A.NR_SEQUENCIA = T.NR_SEQUENCIA_AUTOR)
WHERE M.NR_SEQUENCIA = A.NR_SEQ_DADOS_MOD_REMUN  AND M.NR_SEQ_LOCO_REGIONAL = R.NR_SEQUENCIA AND (NR_SEQ_DADO_CLINICO_W = 0 OR
		M.NR_SEQUENCIA = NR_SEQ_DADO_CLINICO_W) AND R.IE_SITUACAO = 'A' AND NOT EXISTS (	SELECT	1
				FROM	DADOS_CLINICOS_MOD_RETORNO X
				WHERE	X.NR_SEQUENCIA_AUTOR = A.NR_SEQUENCIA) and exists (	select	1
				from	autorizacao_convenio w
				where	w.nr_seq_dados_mod_remun = m.nr_sequencia
				and	w.nr_sequencia < a.nr_sequencia
				and	w.ie_tipo_autorizacao = '3');


C_PEND_W	C_PEND%ROWTYPE;
ds_erro_w	autorizacao_convenio_hist.ds_historico%type;

/*

PROCEDURE PARA LER TODOS AS AUTORIZACOES GERADAS DO TIPO PROCEDIMENTO QUE AINDA NAO CONSULTARAM ELEGIBILIDADE PARA OBTER A CLASSIFICACAO

*/
BEGIN
NR_SEQ_DADO_CLINICO_W := 	COALESCE(nr_seq_dados_clinicos_p,0);

open C_PEND;
loop
fetch C_PEND into
	C_PEND_W;
EXIT WHEN NOT FOUND; /* apply on C_PEND */
	BEGIN
	
	
	IF 	(C_PEND_W.nr_carteira IS NOT NULL AND C_PEND_W.nr_carteira::text <> '') and
		(C_PEND_W.cd_prestador IS NOT NULL AND C_PEND_W.cd_prestador::text <> '') THEN
		
			
		
		INSERT	INTO DADOS_CLINICOS_MOD_RETORNO(
			NR_SEQUENCIA,
			DT_ATUALIZACAO,        
			NM_USUARIO,
			DT_ATUALIZACAO_NREC,      
			NM_USUARIO_NREC,  
			NR_SEQ_DADOS_CLINICOS,   
			NR_CARTEIRA,
			DS_REDE_CLIENTE,
			DS_STATUS,
			CD_PRESTADOR, 
			IE_SITUACAO_ELEG,
			NR_SEQUENCIA_AUTOR)
		
		VALUES (nextval('dados_clinicos_mod_retorno_seq'),    
			clock_timestamp(),        
			NM_USUARIO_P,
			clock_timestamp(),      
			NM_USUARIO_P,  
			C_PEND_W.NR_SEQ_DADOS_MOD_REMUN,   
			C_PEND_W.NR_CARTEIRA,
			NULL,
			NULL,
			C_PEND_W.CD_PRESTADOR, 
			NULL, --IE_SITUACAO_ELEG,
			C_PEND_W.NR_SEQUENCIA_AUTOR);
			
			
			update	autorizacao_convenio a
			set	a.nr_seq_estagio = (	SELECT 	max(x.nr_sequencia)
							from 	estagio_autorizacao x 
							where 	x.ie_interno = '5' 
							and 	x.IE_UTILIZA_MODELO_REMUN = 'S'),
				a.dt_atualizacao = clock_timestamp(),
				a.nm_usuario     = nm_usuario_p
			where	a.nr_sequencia = C_PEND_W.NR_SEQUENCIA_AUTOR;
			
			
			
	
	END IF;

	END;
end loop;
close C_PEND;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE consultar_eleg_taxas_remun ( nr_seq_dados_clinicos_p DADOS_CLINICOS_MOD_REMUN.nr_sequencia%type default null, NM_USUARIO_P USUARIO.NM_USUARIO%TYPE DEFAULT 'job') FROM PUBLIC;

