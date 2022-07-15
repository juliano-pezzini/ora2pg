-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pep_libera_reg_transp ( nr_sequencia_p text, nm_usuario_p text) AS $body$
DECLARE


nr_seq_receptor_w	bigint;
ie_tipo_prof_lib_w	varchar(15);
ie_nao_liberado_w	varchar(1);
ie_contra_indicado_w	varchar(1);

BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	update 	tx_liberacao_lista
	set	DT_LIBERACAO_REGISTRO	= clock_timestamp(),
		NM_USUARIO_LIB_REGISTRO	= nm_usuario_p
	where	nr_sequencia		= nr_sequencia_p;

	select	nr_seq_receptor,
		ie_tipo_prof_lib,
		coalesce(ie_nao_liberado,'N'),
		coalesce(ie_contra_indicado,'N')
	into STRICT	nr_seq_receptor_w,
		ie_tipo_prof_lib_w,
		ie_nao_liberado_w,
		ie_contra_indicado_w
	from	tx_liberacao_lista
	where	nr_sequencia = nr_sequencia_p;

	if (ie_tipo_prof_lib_w = 'MC') then
		CALL Inserir_pendencia_soroteca(nr_seq_receptor_w,nm_usuario_p,wheb_usuario_pck.get_cd_estabelecimento,ie_nao_liberado_w,ie_contra_indicado_w);

	end if;


end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pep_libera_reg_transp ( nr_sequencia_p text, nm_usuario_p text) FROM PUBLIC;

