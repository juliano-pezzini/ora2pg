-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desvincular_contrato_princ ( nr_seq_contrato_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_contrato_principal_w		bigint;
cd_contrato_principal_w		bigint;
nr_seq_pagador_w		bigint;
nr_seq_segurado_w		bigint;
nm_segurado_w			varchar(255);
nm_pagador_w			varchar(255);
ds_historico_w			varchar(255);
nr_seq_contratante_princ_w	bigint;
nm_contratante_princ_w		varchar(255);

C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_contrato_pagador
	where	nr_seq_contrato	= nr_contrato_principal_w;

C02 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_segurado
	where	nr_seq_contrato	= nr_seq_contrato_p;


BEGIN

select	nr_contrato_principal,
	cd_contrato_principal
into STRICT	nr_contrato_principal_w,
	cd_contrato_principal_w
from	pls_contrato
where	nr_sequencia	= nr_seq_contrato_p;


open C01;
loop
fetch C01 into	
	nr_seq_pagador_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_segurado_w
	from	pls_segurado		a,
		pls_contrato_pagador	b
	where	a.nr_seq_contrato	= nr_seq_contrato_p
	and	a.nr_seq_pagador	= b.nr_sequencia
	and	b.nr_sequencia		= nr_seq_pagador_w
	and	((coalesce(a.dt_rescisao::text, '') = '') or (a.dt_rescisao > clock_timestamp()));
	
	if (nr_seq_segurado_w IS NOT NULL AND nr_seq_segurado_w::text <> '') then
			
		select	obter_nome_pf(cd_pessoa_fisica)
		into STRICT	nm_segurado_w
		from	pls_segurado
		where	nr_sequencia	= nr_seq_segurado_w;
		
		select	obter_nome_pf_pj(cd_pessoa_fisica,cd_cgc)
		into STRICT	nm_pagador_w
		from	pls_contrato_pagador
		where	nr_sequencia	= nr_seq_pagador_w;
		
		CALL wheb_mensagem_pck.exibir_mensagem_abort(233307, 'NR_SEQ_SEGURADO=' || nr_seq_segurado_w || ';NM_SEGURADO=' || nm_segurado_w || ';NR_SEQ_PAGADOR=' || nr_seq_pagador_w || ';NM_PAGADOR=' || nm_pagador_w);
		/* Mensagem: Não é possível desvincular o contrato principal. O beneficiário NR_SEQ_SEGURADO - NM_SEGURADO está vinculado ao pagador NR_SEQ_PAGADOR - NM_PAGADOR. */

			
	end if;	
	end;
end loop;
close C01;

open C02;
loop
fetch C02 into	
	nr_seq_segurado_w;
EXIT WHEN NOT FOUND; /* apply on C02 */
	begin
	select	max(nr_seq_contratante_princ)
	into STRICT	nr_seq_contratante_princ_w
	from	pls_segurado
	where	nr_sequencia = nr_seq_segurado_w;
	
	if (nr_seq_contratante_princ_w IS NOT NULL AND nr_seq_contratante_princ_w::text <> '') then
		select	obter_nome_pf(cd_pessoa_fisica)
		into STRICT	nm_contratante_princ_w
		from	pls_segurado
		where	nr_sequencia	= nr_seq_contratante_princ_w;
		
		update	pls_segurado
		set	nr_seq_contratante_princ	 = NULL
		where	nr_sequencia			= nr_seq_segurado_w;
		
		ds_historico_w	:= 'Desvinculado o contratante principal ' || nr_seq_contratante_princ_w || ' - ' || nm_contratante_princ_w || '.';		

		CALL pls_gerar_segurado_historico(	nr_seq_segurado_w, '26', clock_timestamp(), 'Contrato principal desvinculado',
						ds_historico_w, null, null, null,
						null, clock_timestamp(), null, null,
						null, null, null, null,
						nm_usuario_p, 'N');				
	end if;
	end;
end loop;
close C02;

update	pls_contrato
set	nr_contrato_principal	 = NULL,
	cd_contrato_principal	 = NULL
where	nr_sequencia		= nr_seq_contrato_p;

ds_historico_w	:= 'Desvinculado o contrato principal ' || cd_contrato_principal_w || '.';

insert	into	pls_contrato_historico(	nr_sequencia, cd_estabelecimento, nr_seq_contrato, dt_historico, ie_tipo_historico,
		dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
		ds_historico, nm_usuario_historico, ds_titulo)
	values (	nextval('pls_contrato_historico_seq'), cd_estabelecimento_p, nr_seq_contrato_p,
		clock_timestamp(), '26', clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p,
		ds_historico_w, nm_usuario_p, 'Contrato principal desvinculado');
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desvincular_contrato_princ ( nr_seq_contrato_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
