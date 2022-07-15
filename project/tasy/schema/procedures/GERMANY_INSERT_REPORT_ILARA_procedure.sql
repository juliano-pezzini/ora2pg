-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE germany_insert_report_ilara ( nr_laudo_p bigint, ds_arquivo_imagem_p text, nr_seq_empresa_p bigint) AS $body$
DECLARE


ie_existe_w	varchar(1);
nr_seq_imagem_w	laudo_paciente_imagem.nr_seq_imagem%TYPE;
nr_seq_laudo_w		bigint;
nr_seq_prescr_w		bigint;
nr_prescr_w		bigint;

ds_pasta_exp_xml_w	varchar(2000);


BEGIN
/*This procedure inserts the existent file received from Ilara - Segment TXA*/

begin
select	ds_caminho_entrada
into STRICT	ds_pasta_exp_xml_w
from    empresa_integr_dados a,
	empresa_integracao b,
	sistema_integracao c
where	a.nr_seq_empresa_integr = b.nr_sequencia
and	b.nr_sequencia = c.nr_seq_empresa
and     b.nr_sequencia = nr_seq_empresa_p;

SELECT	CASE WHEN COUNT(*)=0 THEN 'N'  ELSE 'S' END
INTO STRICT 	ie_existe_w
FROM 	laudo_paciente_imagem a
WHERE 	a.nr_sequencia = nr_laudo_p
AND  	a.ds_arquivo_imagem = ds_arquivo_imagem_p;

IF (ie_existe_w = 'N') THEN
	SELECT	coalesce(MAX(a.nr_seq_imagem),0)+1
	INTO STRICT 	nr_seq_imagem_w
	FROM 	laudo_paciente_imagem a
	WHERE 	a.nr_sequencia = nr_laudo_p;

	INSERT INTO laudo_paciente_imagem(
		nr_sequencia,
		nr_seq_imagem,
		ds_arquivo_imagem,
		nm_usuario,
		dt_atualizacao,
		ds_imagem)
	VALUES ( nr_laudo_p,
		nr_seq_imagem_w,
		ds_pasta_exp_xml_w||ds_arquivo_imagem_p,
		'ILARA',
		clock_timestamp(),
		ds_arquivo_imagem_p);
	COMMIT;
END IF;
exception
when others then
	CALL gravar_log_cdi(7000,
			nr_laudo_p || '#@#@' || '#@#@' || nr_seq_empresa_p || '#@#@' || dbms_utility.format_error_backtrace,
			'GERMANY');
end;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE germany_insert_report_ilara ( nr_laudo_p bigint, ds_arquivo_imagem_p text, nr_seq_empresa_p bigint) FROM PUBLIC;

