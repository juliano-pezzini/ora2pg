-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizapacexclusivo ( NR_SEQUENCIA_P bigint, IE_PAC_EXCLUSIVO_P text, CD_PESSOA_FISICA_P text, DT_PREVISTA_P timestamp, IE_ENCAIXE_P text, CD_ESTABELECIMENTO_P bigint) AS $body$
BEGIN
if (IE_PAC_EXCLUSIVO_P IS NOT NULL AND IE_PAC_EXCLUSIVO_P::text <> '') then
	if (IE_PAC_EXCLUSIVO_P = 'S') then
		UPDATE checkup SET ie_exclusivo = 'S' WHERE nr_sequencia_p = nr_sequencia;
	else
		UPDATE checkup SET ie_exclusivo = 'N' WHERE nr_sequencia_p = nr_sequencia;
	end if;
	CALL VALIDA_QT_CHECKUP_EXCLUSIVO(CD_PESSOA_FISICA_P,DT_PREVISTA_P,IE_ENCAIXE_P,CD_ESTABELECIMENTO_P,null,null);
end if;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizapacexclusivo ( NR_SEQUENCIA_P bigint, IE_PAC_EXCLUSIVO_P text, CD_PESSOA_FISICA_P text, DT_PREVISTA_P timestamp, IE_ENCAIXE_P text, CD_ESTABELECIMENTO_P bigint) FROM PUBLIC;
