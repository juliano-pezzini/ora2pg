-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_sib_reenvio_conferencia ( nr_seq_conferencia_p pls_sib_conferencia.nr_sequencia%type, ie_tipo_movimento_reenvio_p pls_sib_reenvio.ie_tipo_movimento%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


qt_registro_w		integer;
nr_seq_segurado_w	pls_sib_conferencia.nr_seq_segurado%type;
nr_seq_reenvio_w	pls_sib_reenvio.nr_sequencia%type;
cd_atributo_w		pls_sib_reenvio_atrib.cd_atributo%type;

C01 CURSOR FOR
	SELECT	b.cd_divergencia
	from	pls_sib_conf_divergencia a,
		pls_sib_divergencia_conf b
	where	b.nr_sequencia		= a.nr_seq_divergencia
	and	a.nr_seq_conferencia	= nr_seq_conferencia_p
	and	b.cd_divergencia not in (28,29,30,31,32);

BEGIN

select	count(1)
into STRICT	qt_registro_w
from	pls_sib_reenvio
where	nr_seq_conferencia	= nr_seq_conferencia_p
and	ie_tipo_movimento	= ie_tipo_movimento_reenvio_p
and	coalesce(nr_seq_lote_sib::text, '') = '';

if (qt_registro_w > 0) then --Já existe re-envio de #@DS_TIPO_MOVIMENTO#@ pendente para o registro de conferência. Favor verifique.
	CALL wheb_mensagem_pck.exibir_mensagem_abort(834399,'DS_TIPO_MOVIMENTO='||obter_valor_dominio(8352,ie_tipo_movimento_reenvio_p));
else
	select	max(nr_seq_segurado)
	into STRICT	nr_seq_segurado_w
	from	pls_sib_conferencia
	where	nr_sequencia	= nr_seq_conferencia_p;
	
	if (nr_seq_segurado_w IS NOT NULL AND nr_seq_segurado_w::text <> '') then
		insert	into	pls_sib_reenvio(	nr_sequencia, nr_seq_conferencia, ie_tipo_movimento, cd_estabelecimento,
				dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec,
				nr_seq_segurado)
			values (	nextval('pls_sib_reenvio_seq'), nr_seq_conferencia_p, ie_tipo_movimento_reenvio_p, cd_estabelecimento_p,
				clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p,
				nr_seq_segurado_w)
			returning nr_sequencia into nr_seq_reenvio_w;
		
		if (ie_tipo_movimento_reenvio_p = 2) then
			--Se for Retificação, o sistema irá reenviar os atributos que apresentaram inconsistência
			for r_c01_w in C01 loop
				begin
				cd_atributo_w	:= null;
				--Domínio cd_atributo_w=8369
				if (r_c01_w.cd_divergencia = 1) then
					cd_atributo_w	:= 1; --Nome
				elsif (r_c01_w.cd_divergencia = 2) then
					cd_atributo_w	:= 4; --CPF
				elsif (r_c01_w.cd_divergencia = 3) then
					cd_atributo_w	:= 36; --Número da Declaração de Nascido Vivo
				elsif (r_c01_w.cd_divergencia = 4) then
					cd_atributo_w	:= 5; --Pis/Pasep
				elsif (r_c01_w.cd_divergencia = 5) then
					cd_atributo_w	:= 7; --CNS
				elsif (r_c01_w.cd_divergencia = 6) then
					cd_atributo_w	:= 3; --Sexo
				elsif (r_c01_w.cd_divergencia = 7) then
					cd_atributo_w	:= 2; --Data de nascimento
				elsif (r_c01_w.cd_divergencia = 8) then
					cd_atributo_w	:= 6; --Nome da mãe
				elsif (r_c01_w.cd_divergencia = 9) then
					cd_atributo_w	:= 13; --Relação de Dependência
				elsif (r_c01_w.cd_divergencia = 10) then
					cd_atributo_w	:= 12; --Data de contratação
				elsif (r_c01_w.cd_divergencia = 11) then
					cd_atributo_w	:= 20; --Data de reativação
				elsif (r_c01_w.cd_divergencia = 12) then
					cd_atributo_w	:= 31; --Data de cancelamento
				elsif (r_c01_w.cd_divergencia = 13) then
					cd_atributo_w	:= 32; --Motivo do cancelamento
				elsif (r_c01_w.cd_divergencia = 14) then
					insert into pls_sib_reenvio_atrib(	nr_sequencia, nr_seq_reenvio, cd_atributo,
							dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec)
						values (	nextval('pls_sib_reenvio_atrib_seq'), nr_seq_reenvio_w, 9, --RPS - Protocolo ANS
							clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p);
					
					insert into pls_sib_reenvio_atrib(	nr_sequencia, nr_seq_reenvio, cd_atributo,
							dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec)
						values (	nextval('pls_sib_reenvio_atrib_seq'), nr_seq_reenvio_w, 10, --SCPA
							clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p);
				elsif (r_c01_w.cd_divergencia = 15) then
					cd_atributo_w	:= 14; --CPT
				elsif (r_c01_w.cd_divergencia = 16) then
					cd_atributo_w	:= 15; --Itens excluídos da cobertura
				elsif (r_c01_w.cd_divergencia = 17) then
					cd_atributo_w	:= 16; --CNPJ
				elsif (r_c01_w.cd_divergencia = 18) then
					cd_atributo_w	:= 17; --CEI
				elsif (r_c01_w.cd_divergencia = 33) then
          					cd_atributo_w	:= 37; --CAEPF
				elsif (r_c01_w.cd_divergencia = 19) then
					cd_atributo_w	:= 28; --Reside no exterior
				elsif (r_c01_w.cd_divergencia = 20) then
					cd_atributo_w	:= 21; --Indicação de endereço residencial ou profissional
				elsif (r_c01_w.cd_divergencia = 21) then
					cd_atributo_w	:= 27; --CEP
				elsif (r_c01_w.cd_divergencia = 22) then
					cd_atributo_w	:= 22; --Logradouro
				elsif (r_c01_w.cd_divergencia = 23) then
					cd_atributo_w	:= 33; --Nº logradouro
				elsif (r_c01_w.cd_divergencia = 24) then
					cd_atributo_w	:= 34; --Complemento
				elsif (r_c01_w.cd_divergencia = 25) then
					cd_atributo_w	:= 35; --Bairro
				elsif (r_c01_w.cd_divergencia = 26) then
					cd_atributo_w	:= 26; --Município
				elsif (r_c01_w.cd_divergencia = 27) then
					cd_atributo_w	:= 29; --Município de residência
				end if;
				
				if (cd_atributo_w IS NOT NULL AND cd_atributo_w::text <> '') then
					insert into pls_sib_reenvio_atrib(	nr_sequencia, nr_seq_reenvio, cd_atributo,
							dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec)
						values (	nextval('pls_sib_reenvio_atrib_seq'), nr_seq_reenvio_w, cd_atributo_w,
							clock_timestamp(), nm_usuario_p, clock_timestamp(), nm_usuario_p);
				end if;
				end;
			end loop;
		end if;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sib_reenvio_conferencia ( nr_seq_conferencia_p pls_sib_conferencia.nr_sequencia%type, ie_tipo_movimento_reenvio_p pls_sib_reenvio.ie_tipo_movimento%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

