-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gravar_inconsist_inclusao ( nr_seq_inclusao_p bigint, cd_inconsistencia_p bigint, nr_seq_lote_p bigint, nr_seq_inclusao_sca_p bigint, nm_usuario_p text) AS $body$
DECLARE

				
ds_inconsistencia_w		varchar(255);
nr_seq_inconsistencia_w		bigint;
ie_situacao_w			varchar(10);
ie_tipo_contrato_w		pls_inconsistencia_inc_seg.ie_tipo_contrato%type;
nr_seq_contrato_w		pls_inclusao_beneficiario.nr_seq_contrato%type;
nr_seq_intercambio_w   		pls_inclusao_beneficiario.nr_seq_intercambio%type;
nr_seq_proposta_w		pls_inclusao_beneficiario.nr_seq_proposta%type;
nr_seq_lote_w			pls_inclusao_beneficiario.nr_sequencia%type;
nr_seq_lote_inclusao_w		pls_inclusao_beneficiario.nr_seq_lote_inclusao%type;
ie_tipo_contrato_regra_w	varchar(10);
qt_inconsistencia_exist_w	bigint;


BEGIN

if (nr_seq_inclusao_p IS NOT NULL AND nr_seq_inclusao_p::text <> '')  then
	begin
	select	ds_inconsistencia,
		nr_sequencia,
		ie_situacao,
		ie_tipo_contrato
	into STRICT	ds_inconsistencia_w,
		nr_seq_inconsistencia_w,
		ie_situacao_w,
		ie_tipo_contrato_w
	from	pls_inconsistencia_inc_seg
	where	cd_inconsistencia = cd_inconsistencia_p
	and	ie_utilizacao in ('A','P');
	exception
	when others then
		ds_inconsistencia_w	:= '';
	end;	
	
	select  count(1)
	into STRICT 	qt_inconsistencia_exist_w
	from 	pls_inconsist_incl_benef
	where 	nr_seq_solic_inclusao = nr_seq_inclusao_p
	and 	nr_seq_inconsistencia = nr_seq_inconsistencia_w
	and (coalesce(nr_seq_inclusao_sca::text, '') = '' or nr_seq_inclusao_sca = nr_seq_inclusao_sca_p);

	if (qt_inconsistencia_exist_w = 0) then
		select	nr_seq_lote_inclusao,
			nr_seq_contrato,
			nr_seq_intercambio
		into STRICT	nr_seq_lote_inclusao_w,
			nr_seq_contrato_w,
			nr_seq_intercambio_w
		from 	pls_inclusao_beneficiario
		where nr_sequencia = nr_seq_inclusao_p;

		if (nr_seq_lote_inclusao_w IS NOT NULL AND nr_seq_lote_inclusao_w::text <> '') then
			select 	nr_seq_contrato,
				nr_seq_intercambio
			into STRICT	nr_seq_contrato_w,
				nr_seq_intercambio_w
			from 	pls_lote_inclusao_benef
			where 	nr_sequencia = nr_seq_lote_inclusao_w;	
		end if;
		
		if (nr_seq_intercambio_w IS NOT NULL AND nr_seq_intercambio_w::text <> '') then
			ie_tipo_contrato_regra_w := 'I';

		elsif (nr_seq_contrato_w IS NOT NULL AND nr_seq_contrato_w::text <> '') then
			ie_tipo_contrato_regra_w := 'O';
		end if;
		
		if (ie_situacao_w = 'A') then
			if 	((ie_tipo_contrato_w = 'A') or ((ie_tipo_contrato_w = 'O' AND ie_tipo_contrato_regra_w = 'O')
				or (ie_tipo_contrato_w = 'I' AND ie_tipo_contrato_regra_w = 'I'))) then
				
				insert into pls_inconsist_incl_benef(	nr_sequencia, dt_atualizacao, dt_atualizacao_nrec,
						nm_usuario, nm_usuario_nrec, nr_seq_solic_inclusao,
						ds_inconsistencia, nr_seq_lote,nr_seq_inconsistencia,
						nr_seq_inclusao_sca)
				values (	nextval('pls_inconsist_incl_benef_seq'), clock_timestamp(), clock_timestamp(),
						nm_usuario_p, nm_usuario_p, nr_seq_inclusao_p,
						ds_inconsistencia_w, nr_seq_lote_p,nr_seq_inconsistencia_w,
						nr_seq_inclusao_sca_p);
			end if;
		end if;
	end if;
	
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gravar_inconsist_inclusao ( nr_seq_inclusao_p bigint, cd_inconsistencia_p bigint, nr_seq_lote_p bigint, nr_seq_inclusao_sca_p bigint, nm_usuario_p text) FROM PUBLIC;

