-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_buscar_familia_pf (ie_tipo_incremento_p text, cd_matricula_familia_p bigint, cd_matricula_familia_pp bigint, nr_seq_regra_p bigint, nr_seq_contrato_p bigint, nr_seq_segurado_p bigint, nr_seq_intercambio_p bigint, nm_usuario_p text, cd_operadora_empresa_p bigint, cd_matricula_p INOUT bigint) AS $body$
DECLARE


cd_atual_w			bigint;
cd_inicial_w			bigint;
cd_final_w			bigint;
cd_regra_w			bigint;
cd_operadora_empresa_w		bigint;
cd_matricula_w			bigint;
cd_matricula_familia_ww		bigint;


BEGIN
/*Sequencial */

if (ie_tipo_incremento_p	= 'SQ') then

	cd_matricula_w := pls_buscar_familia_pf_seq( ie_tipo_incremento_p, cd_matricula_familia_p, cd_matricula_familia_pp, nr_seq_regra_p, nr_seq_contrato_p, nr_seq_segurado_p, nr_seq_intercambio_p, nm_usuario_p, cd_operadora_empresa_p, cd_matricula_w);
/*Sequencia por empresa*/

elsif (ie_tipo_incremento_p	= 'SE') then

	cd_operadora_empresa_w := cd_operadora_empresa_p;

	if (cd_operadora_empresa_w IS NOT NULL AND cd_operadora_empresa_w::text <> '') then
		if (coalesce(cd_matricula_familia_p,0) = 0) then
			begin
			select	max(cd_inicial),
				max(cd_atual),
				coalesce(max(cd_final),0)
			into STRICT	cd_inicial_w,
				cd_atual_w,
				cd_final_w
			from	pls_carteira_controle_iden
			where	nr_sequencia	= nr_seq_regra_p;
			exception
			when others then
				cd_inicial_w := 1;
			end;

			cd_regra_w :=	cd_inicial_w;

			--Alterado para verificar se existe código limite da regra, caso a mesma tenha, deverá dar um max apenas dentro da faixa de códigos da regra
			if (cd_final_w > 0) then
				begin
				select	max(cd_matricula_familia)
				into STRICT	cd_matricula_familia_ww
				from	pls_segurado
				where	cd_operadora_empresa	= cd_operadora_empresa_w
				and	cd_matricula_familia	<= cd_final_w;
				exception
				when others then
					cd_matricula_familia_ww	:= 0;
				end;
			else
				begin
				select	max(cd_matricula_familia)
				into STRICT	cd_matricula_familia_ww
				from	pls_segurado
				where	cd_operadora_empresa	= cd_operadora_empresa_w;
				exception
				when others then
					cd_matricula_familia_ww	:= 0;
				end;
			end if;

			if (coalesce(cd_matricula_familia_ww,0) = 0) then

				cd_matricula_w	:=  cd_regra_w;

			elsif (coalesce(cd_matricula_familia_ww,0) > 0) then

				cd_matricula_w	:= cd_matricula_familia_ww +1;
			end if;

		else
			if (coalesce(cd_matricula_familia_ww,0) <> coalesce(cd_matricula_familia_p,0)) then

				cd_matricula_w	:=  cd_matricula_familia_p;

			end if;
		end if;
	end if;
/* Sequencia por contrato*/

elsif (ie_tipo_incremento_p	= 'SC') then

	if (coalesce(cd_matricula_familia_p,0) = 0) then
		begin
		select	max(cd_inicial),
			max(cd_atual),
			coalesce(max(cd_final),0)
		into STRICT	cd_inicial_w,
			cd_atual_w,
			cd_final_w
		from	pls_carteira_controle_iden
		where	nr_sequencia	= nr_seq_regra_p;
		exception
		when others then
			cd_inicial_w := 1;
		end;

		cd_regra_w :=	cd_inicial_w;

		--Alterado para verificar se existe código limite da regra, caso a mesma tenha, deverá dar um max apenas dentro da faixa de códigos da regra
		if (cd_final_w > 0) then
			if (nr_seq_contrato_p IS NOT NULL AND nr_seq_contrato_p::text <> '') then
				begin
				select	max(cd_matricula_familia)
				into STRICT	cd_matricula_familia_ww
				from	pls_segurado
				where	nr_seq_contrato	= nr_seq_contrato_p
				and	cd_matricula_familia	<= cd_final_w;
				exception
				when others then
					cd_matricula_familia_ww	:= 0;
				end;
			elsif (nr_seq_intercambio_p IS NOT NULL AND nr_seq_intercambio_p::text <> '') then
				begin
				select	max(cd_matricula_familia)
				into STRICT	cd_matricula_familia_ww
				from	pls_segurado
				where	nr_seq_intercambio	= nr_seq_intercambio_p
				and	cd_matricula_familia	<= cd_final_w;
				exception
				when others then
					cd_matricula_familia_ww	:= 0;
				end;
			end if;
		else
			if (nr_seq_contrato_p IS NOT NULL AND nr_seq_contrato_p::text <> '') then
				begin
				select	max(cd_matricula_familia)
				into STRICT	cd_matricula_familia_ww
				from	pls_segurado
				where	nr_seq_contrato	= nr_seq_contrato_p;
				exception
				when others then
					cd_matricula_familia_ww	:= 0;
				end;
			elsif (nr_seq_intercambio_p IS NOT NULL AND nr_seq_intercambio_p::text <> '') then
				begin
				select	max(cd_matricula_familia)
				into STRICT	cd_matricula_familia_ww
				from	pls_segurado
				where	nr_seq_intercambio	= nr_seq_intercambio_p;
				exception
				when others then
					cd_matricula_familia_ww	:= 0;
				end;
			end if;
		end if;

		if (coalesce(cd_matricula_familia_ww,0) = 0) then

			cd_matricula_w	:=  cd_regra_w;

		elsif (coalesce(cd_matricula_familia_ww,0) > 0) then
			cd_matricula_w	:= cd_matricula_familia_ww +1;
		end if;
	else
		if (coalesce(cd_matricula_familia_ww,0) <> coalesce(cd_matricula_familia_p,0)) then

			cd_matricula_w	:=  cd_matricula_familia_p;
		end if;
	end if;
end if;

cd_matricula_p := cd_matricula_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_buscar_familia_pf (ie_tipo_incremento_p text, cd_matricula_familia_p bigint, cd_matricula_familia_pp bigint, nr_seq_regra_p bigint, nr_seq_contrato_p bigint, nr_seq_segurado_p bigint, nr_seq_intercambio_p bigint, nm_usuario_p text, cd_operadora_empresa_p bigint, cd_matricula_p INOUT bigint) FROM PUBLIC;
