-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_alterar_subestipulante ( nr_seq_subestipulante_p bigint, nr_seq_segurado_p bigint, dt_geracao_sib_p timestamp, ie_dependentes_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


nm_subestipulante_w		varchar(255);
nr_seq_segurado_w		bigint;
ie_subestipulante_depen_w	varchar(10);
qt_titular_w			bigint;
ds_erro_w			varchar(255);
nr_seq_titular_w		bigint;
nr_seq_subestipulante_tit_w	bigint;


C01 CURSOR FOR
	SELECT	nr_sequencia
	from	pls_segurado
	where	nr_seq_titular	= nr_seq_segurado_p;


BEGIN

ie_subestipulante_depen_w := coalesce(obter_valor_param_usuario(1202, 64, Obter_Perfil_Ativo, nm_usuario_p, cd_estabelecimento_p),'S');

CALL pls_consiste_data_sib(dt_geracao_sib_p, nm_usuario_p, cd_estabelecimento_p);

if (ie_subestipulante_depen_w = 'N') then
	select	count(*)
	into STRICT	qt_titular_w
	from	pls_segurado
	where	nr_seq_titular	= nr_seq_segurado_p;
	
	if (qt_titular_w > 0) then
		if (ie_dependentes_p = 'N') then
			ds_erro_w	:= wheb_mensagem_pck.get_texto(1196185);
		end if;
	else
		begin
		select	max(nr_seq_titular)
		into STRICT	nr_seq_titular_w
		from	pls_segurado
		where	nr_sequencia	= nr_seq_segurado_p;
		exception
		when others then
			nr_seq_titular_w := null;
		end;
		
		if (nr_seq_titular_w IS NOT NULL AND nr_seq_titular_w::text <> '') then
			begin
			select	max(nr_seq_subestipulante)
			into STRICT	nr_seq_subestipulante_tit_w
			from	pls_segurado
			where	nr_sequencia = nr_seq_titular_w;
			exception
			when others then
				nr_seq_subestipulante_tit_w	:= null;
			end;
			
			if (nr_seq_subestipulante_tit_w IS NOT NULL AND nr_seq_subestipulante_tit_w::text <> '') then
				if (nr_seq_subestipulante_tit_w	<> nr_seq_subestipulante_p) then
					ds_erro_w := wheb_mensagem_pck.get_texto(1196183);
				end if;
			end if;
		end if;
	end if;
	
	if (ds_erro_w IS NOT NULL AND ds_erro_w::text <> '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(265205,'DS_ERRO='||ds_erro_w);
		--Mensagem: O subestipulante do dependente nao pode ser diferente do titular.

		--O beneficiario titular possui dependentes vinculados, favor selecionar para alterar o subestipulante para eles  tambem.			
	end if;
end if;	

select	substr(pls_obter_desc_subestipulante(nr_seq_subestipulante),1,255)
into STRICT	nm_subestipulante_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;

update	pls_segurado
set	nr_seq_subestipulante	= nr_seq_subestipulante_p,
	nm_usuario		= nm_usuario_p,
	dt_atualizacao		= clock_timestamp()
where	nr_sequencia		= nr_seq_segurado_p;

/* Gerar historico */

CALL pls_gerar_segurado_historico(
	nr_seq_segurado_p, '11', clock_timestamp(),
	'pls_alterar_subestipulante', 'Sub-estipulante anterior: ' || nm_subestipulante_w, null,
	null, null, null, 
	dt_geracao_sib_p, null, null, 
	null, null, null, 
	null, nm_usuario_p, 'S');

if (ie_dependentes_p	= 'S') then
	open C01;
	loop
	fetch C01 into	
		nr_seq_segurado_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		
		select	substr(pls_obter_desc_subestipulante(nr_seq_subestipulante),1,255)
		into STRICT	nm_subestipulante_w
		from	pls_segurado
		where	nr_sequencia	= nr_seq_segurado_w;

		update	pls_segurado
		set	nr_seq_subestipulante	= nr_seq_subestipulante_p,
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
		where	nr_sequencia		= nr_seq_segurado_w;
		
		/* Gerar historico */

		CALL pls_gerar_segurado_historico(
			nr_seq_segurado_w, '11', clock_timestamp(),
			'pls_alterar_subestipulante', 'Sub-estipulante anterior: ' || nm_subestipulante_w, null,
			null, null, null, 
			dt_geracao_sib_p, null, null, 
			null, null, null, 
			null, nm_usuario_p, 'S');
		
		end;
	end loop;
	close C01;
end if;	

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_alterar_subestipulante ( nr_seq_subestipulante_p bigint, nr_seq_segurado_p bigint, dt_geracao_sib_p timestamp, ie_dependentes_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
