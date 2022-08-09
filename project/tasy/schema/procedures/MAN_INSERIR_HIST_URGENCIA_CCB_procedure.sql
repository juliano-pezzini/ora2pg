-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_inserir_hist_urgencia_ccb ( nr_seq_ordem_serv_p bigint, nm_usuario_p text ) AS $body$
DECLARE


ds_relat_tecnico_w		varchar(8000);


BEGIN

ds_relat_tecnico_w := wheb_rtf_pck.get_cabecalho;
ds_relat_tecnico_w := ds_relat_tecnico_w || wheb_rtf_pck.get_fonte(20);
ds_relat_tecnico_w := ds_relat_tecnico_w || 'To be defined by Q' || chr(38) /* E comercial */ || 'R and DEC';
ds_relat_tecnico_w := ds_relat_tecnico_w || wheb_rtf_pck.get_rodape;

CALL man_gravar_historico_ordem(
	nr_seq_ordem_serv_p,
	clock_timestamp(), -- dt_liberacao_p
	ds_relat_tecnico_w,
	'I', -- ie_origem_p
	190, -- nr_seq_tipo_p (Exceção do CCB para urgências fora do horário comercial)
	nm_usuario_p
);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_inserir_hist_urgencia_ccb ( nr_seq_ordem_serv_p bigint, nm_usuario_p text ) FROM PUBLIC;
