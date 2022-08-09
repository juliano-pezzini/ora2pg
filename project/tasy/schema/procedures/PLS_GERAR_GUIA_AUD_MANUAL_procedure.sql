-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_guia_aud_manual ( nr_seq_guia_p bigint, nr_seq_ocorrencia_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
nr_seq_auditoria_w		bigint := 0;
nr_seq_grupo_w			bigint;
nr_seq_fluxo_w			bigint;
qt_grupo_w			integer;
nr_seq_segurado_w		bigint;
qt_fluxo_w			integer;
nr_seq_ordem_atual_w		bigint;
ie_auditoria_w			pls_ocorrencia.ie_auditoria%type;
ie_utiliza_nivel_w		varchar(1);
cd_estabelecimento_w		pls_guia_plano.cd_estabelecimento%type;

C01 CURSOR FOR 
	SELECT 	nr_seq_grupo, 
		nr_seq_fluxo 
	from	pls_ocorrencia_grupo 
	where	nr_seq_ocorrencia	= nr_seq_ocorrencia_p 
	and	ie_autorizacao		= 'S';
	

BEGIN 
 
begin 
select	nr_seq_segurado, 
	cd_estabelecimento 
into STRICT	nr_seq_segurado_w, 
	cd_estabelecimento_w 
from	pls_guia_plano 
where	nr_sequencia	= nr_seq_guia_p;
exception 
when others then 
	nr_seq_segurado_w := null;
end;
	 
if (nr_seq_guia_p IS NOT NULL AND nr_seq_guia_p::text <> '') then 
	CALL pls_gerar_auditoria_guia(nr_seq_guia_p, nm_usuario_p);		
end if;
 
begin 
	select	nr_sequencia 
	into STRICT	nr_seq_auditoria_w 
	from	pls_auditoria 
	where	nr_seq_guia 	= nr_seq_guia_p 
	and	coalesce(dt_liberacao::text, '') = '';
exception 
when others then 
	nr_seq_auditoria_w := 0;
end;
 
if (nr_seq_auditoria_w > 0) then 
 
	begin 
		select	ie_auditoria 
		into STRICT	ie_auditoria_w 
		from	pls_ocorrencia 
		where	nr_sequencia	= nr_seq_ocorrencia_p;
	exception 
	when others then 
		ie_auditoria_w	:= '';
	end;
	 
	insert into pls_ocorrencia_benef(nr_sequencia, 
		nr_seq_segurado, 
		nr_seq_ocorrencia, 
		dt_atualizacao, 
		nm_usuario, 
		dt_atualizacao_nrec, 
		nm_usuario_nrec, 
		nr_seq_requisicao, 
		nr_seq_conta, 
		nr_seq_proc, 
		nr_seq_mat, 
		nr_seq_regra, 
		nr_seq_guia_plano, 
		ie_auditoria, 
		nr_nivel_liberacao, 
		ds_observacao) 
	values (nextval('pls_ocorrencia_benef_seq'), 
		nr_seq_segurado_w, 
		nr_seq_ocorrencia_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		clock_timestamp(), 
		nm_usuario_p, 
		null, 
		null, 
		null, 
		null, 
		null, 
		nr_seq_guia_p, 
		ie_auditoria_w, 
		null, 
		'Ocorrência gerada através do envio manual da guia para auditoria');
		 
	ie_utiliza_nivel_w := pls_obter_se_uti_nivel_lib_aut(cd_estabelecimento_w);
	if (ie_utiliza_nivel_w = 'S') then 
		CALL pls_gerar_ocorr_glosa_aud_aut(nr_seq_auditoria_w,nm_usuario_p);
	end if;
 
	open C01;
	loop 
	fetch C01 into	 
		nr_seq_grupo_w, 
		nr_seq_fluxo_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin 
		select	count(1) 
		into STRICT	qt_grupo_w 
		from	pls_auditoria_grupo 
		where	nr_seq_auditoria 	= nr_seq_auditoria_w 
		and	nr_seq_grupo 		= nr_seq_grupo_w;
		 
		if (qt_grupo_w = 0) then 
		 
			select	count(1) 
			into STRICT	qt_fluxo_w 
			from	pls_auditoria_grupo 
			where	nr_seq_auditoria 	= nr_seq_auditoria_w 
			and	nr_seq_ordem 		= nr_seq_fluxo_w;
			 
			if (qt_fluxo_w	> 0) then 
				select	max(nr_seq_ordem) + 1 
				into STRICT	nr_seq_ordem_atual_w 
				from	pls_auditoria_grupo 
				where	nr_seq_auditoria 	= nr_seq_auditoria_w;
				 
				nr_seq_fluxo_w	:= nr_seq_ordem_atual_w;
			end if;
			 
			insert into pls_auditoria_grupo(nr_sequencia, 
				nr_seq_auditoria, 
				nr_seq_grupo, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				nr_seq_ordem, 
				ie_status, 
				ie_manual) 
			values (nextval('pls_auditoria_grupo_seq'), 
				nr_seq_auditoria_w, 
				nr_seq_grupo_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				nr_seq_fluxo_w, 
				'U', 
				'N');
		end if;
		end;
	end loop;
	close C01;
	 
	update	pls_guia_plano 
	set	ie_estagio	= 1 
	where	nr_sequencia	= nr_seq_guia_p;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_guia_aud_manual ( nr_seq_guia_p bigint, nr_seq_ocorrencia_p bigint, nm_usuario_p text) FROM PUBLIC;
