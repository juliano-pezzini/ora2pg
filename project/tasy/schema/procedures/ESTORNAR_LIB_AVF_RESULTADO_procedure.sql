-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE estornar_lib_avf_resultado ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


qt_existe_w			bigint;
ie_envia_comunic_w		varchar(1);
nm_usuario_destino_w		varchar(15);
cd_cnpj_w			varchar(14);
ds_razao_social_w			varchar(80);
ds_comunicado_w			varchar(255);
cd_estabelecimento_w		integer;


BEGIN

update	avf_resultado
set	dt_liberacao	= ''
where	nr_sequencia	= nr_sequencia_p;

update	AVF_RESULTADO_ITEM
set	nr_seq_nota_item  = NULL,
	DS_JUSTIFICATIVA  = NULL
where	nr_seq_resultado  = nr_sequencia_p;

select	cd_estabelecimento
into STRICT	cd_estabelecimento_w
from	avf_resultado
where	nr_sequencia = nr_sequencia_p;

CALL sup_cancela_email_pendente(45,nr_sequencia_p,'PJ',cd_estabelecimento_w,nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE estornar_lib_avf_resultado ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

