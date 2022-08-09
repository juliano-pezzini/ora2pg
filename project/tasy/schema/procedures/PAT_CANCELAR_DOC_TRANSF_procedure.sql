-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pat_cancelar_doc_transf (nr_seq_doc_p bigint, nr_seq_motivo_p bigint, ds_justificativa_p text, nm_usuario_p text, ie_opcao_p text, ie_gera_comunic text) AS $body$
DECLARE



texto_comunic_w			varchar(32000);
ds_titulo_w			varchar(255);
nm_usuario_destino_w 		varchar(4000);
ds_motivo_w			varchar(255);


/* ie_opcao
C - Cancela
E - Estorna */
BEGIN

if (upper(ie_opcao_p) = 'C') then
	update 	pat_doc_transferencia
	set	dt_cancelamento 	= clock_timestamp(),
		nr_seq_motivo 	= nr_seq_motivo_p,
		ds_justificativa 	= substr(ds_justificativa_p,1,255),
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where 	nr_sequencia 	= nr_seq_doc_p;

	select 	substr(ds_motivo,1,255)
	into STRICT	ds_motivo_w
	from	pat_doc_mot_cancela
	where	nr_sequencia = nr_seq_motivo_p;

	ds_titulo_w := wheb_mensagem_pck.get_texto(299362);

	texto_comunic_w	:= wheb_mensagem_pck.get_texto(299364,	'NR_SEQ_DOC=' 		|| nr_seq_doc_p || ';' ||
								'DS_MOTIVO=' 		|| ds_motivo_w 	|| ';' ||
								'DS_JUSTIFICATIVA='	|| ds_justificativa_p);

elsif (upper(ie_opcao_p) = 'E') then
	update 	pat_doc_transferencia
	set	dt_cancelamento 	 = NULL,
		nr_seq_motivo 	 = NULL,
		ds_justificativa 	 = NULL,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp()
	where 	nr_sequencia 	= nr_seq_doc_p;

	ds_titulo_w := wheb_mensagem_pck.get_texto(299373);
	texto_comunic_w := wheb_mensagem_pck.get_texto(299375,'NR_SEQ_DOC=' || nr_seq_doc_p);
end if;

if (upper(ie_gera_comunic) = 'S') then

	select	substr(obter_usuario_pf(a.cd_responsavel_transf),1,15) nm_usuario
	into STRICT	nm_usuario_destino_w
	from	pat_doc_transferencia a
	where	a.nr_sequencia = nr_seq_doc_p;

	if (coalesce(nm_usuario_destino_w,'X') <> 'X') then
		CALL Gerar_Comunic_Padrao(clock_timestamp(),ds_titulo_w,texto_comunic_w,nm_usuario_p,'N',nm_usuario_destino_w,'N',null,null,null,null,clock_timestamp(),null,null);
	end if;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pat_cancelar_doc_transf (nr_seq_doc_p bigint, nr_seq_motivo_p bigint, ds_justificativa_p text, nm_usuario_p text, ie_opcao_p text, ie_gera_comunic text) FROM PUBLIC;
